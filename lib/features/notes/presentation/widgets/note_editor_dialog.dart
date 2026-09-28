import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/providers/points_provider.dart';
import '../../../../core/utils/points_floating_animation.dart';
import '../../../badges/providers/badge_provider.dart';
import '../../../courses/data/models/course_model.dart';
import '../../../courses/providers/course_provider.dart';
import '../../data/models/course_note_model.dart';
import '../../data/models/note_template.dart';
import '../providers/notes_provider.dart';
import 'note_card_widget.dart';
import '../../domain/models/comparison_colors.dart';
import '../../../../core/services/speech_service.dart';

class NoteEditorDialog extends ConsumerStatefulWidget {
  final CourseNoteModel? noteToEdit;
  final String? initialGrade;
  final String? initialCourseId;
  final String? initialCourseTitle;
  final int? initialUnitIndex;
  final String? initialUnitTitle;
  final String? initialTag;
  final NoteTemplateType? initialTemplateType;

  const NoteEditorDialog({
    super.key,
    this.noteToEdit,
    this.initialGrade,
    this.initialCourseId,
    this.initialCourseTitle,
    this.initialUnitIndex,
    this.initialUnitTitle,
    this.initialTag,
    this.initialTemplateType,
  });

  static Future<void> show(
    BuildContext context, {
    CourseNoteModel? noteToEdit,
    String? initialGrade,
    String? initialCourseId,
    String? initialCourseTitle,
    int? initialUnitIndex,
    String? initialUnitTitle,
    String? initialTag,
    NoteTemplateType? initialTemplateType,
  }) {
    final isWide = MediaQuery.sizeOf(context).width >= 768;
    final editorWidget = NoteEditorDialog(
      noteToEdit: noteToEdit,
      initialGrade: initialGrade,
      initialCourseId: initialCourseId,
      initialCourseTitle: initialCourseTitle,
      initialUnitIndex: initialUnitIndex,
      initialUnitTitle: initialUnitTitle,
      initialTag: initialTag,
      initialTemplateType: initialTemplateType,
    );

    if (isWide) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => editorWidget,
      );
    } else {
      return Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (context) => editorWidget,
        ),
      );
    }
  }

  @override
  ConsumerState<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _WorkshopStepItem {
  final TextEditingController contentController;
  final FocusNode focusNode;

  _WorkshopStepItem({
    String content = '',
  })  : contentController = TextEditingController(text: content),
        focusNode = FocusNode();

  void dispose() {
    contentController.dispose();
    focusNode.dispose();
  }
}

class _ComparisonFeatureItem {
  final TextEditingController featureTitleController;
  final List<TextEditingController> conceptValuesControllers;
  final FocusNode focusNode;

  _ComparisonFeatureItem({
    String title = '',
    required int conceptCount,
    List<String>? initialValues,
  })  : featureTitleController = TextEditingController(text: title),
        conceptValuesControllers = List.generate(
          conceptCount,
          (i) => TextEditingController(
            text: initialValues != null && i < initialValues.length ? initialValues[i] : '',
          ),
        ),
        focusNode = FocusNode();

  void addConcept({String initialValue = ''}) {
    conceptValuesControllers.add(TextEditingController(text: initialValue));
  }

  void removeConceptAt(int index) {
    if (index >= 0 && index < conceptValuesControllers.length) {
      final ctrl = conceptValuesControllers.removeAt(index);
      ctrl.dispose();
    }
  }

  void dispose() {
    featureTitleController.dispose();
    for (final ctrl in conceptValuesControllers) {
      ctrl.dispose();
    }
    focusNode.dispose();
  }
}

class _NoteEditorDialogState extends ConsumerState<NoteEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _contentFocusNode;
  final List<_WorkshopStepItem> _workshopSteps = [];
  final List<TextEditingController> _comparisonConcepts = [];
  final List<_ComparisonFeatureItem> _comparisonFeatures = [];

  late String _selectedGrade;
  late String _selectedCourseId;
  late String _selectedCourseTitle;
  int? _selectedUnitIndex;
  String? _selectedUnitTitle;

  int _selectedColorIndex = 0;
  String _selectedTag = '';
  late NoteTemplateType _selectedTemplateType;
  bool _isExpanded = false;

  final SpeechService _speechService = SpeechService();
  bool _isListening = false;
  TextEditingController? _activeListeningController;
  String _speechPrefixText = '';
  String _speechSuffixText = '';

  final List<String> _tags = const [
    'Önemli',
    'Sınav',
    'Tanım',
    'Ödev',
    'İpucu',
    'Kişisel',
  ];

  @override
  void initState() {
    super.initState();
    final edit = widget.noteToEdit;
    final hasExplicitInitialTag = widget.initialTag != null &&
        widget.initialTag != 'Tümü' &&
        widget.initialTag!.trim().isNotEmpty;

    _titleController = TextEditingController(text: edit?.title ?? '');
    _contentController = TextEditingController(text: edit?.content ?? '');
    _titleFocusNode = FocusNode();
    _contentFocusNode = FocusNode();

    _selectedGrade = edit?.grade ?? widget.initialGrade ?? '9';
    _selectedCourseId = edit?.courseId ?? widget.initialCourseId ?? 'genel_turizm';
    _selectedCourseTitle = edit?.courseTitle ?? widget.initialCourseTitle ?? 'Genel Turizm';
    _selectedUnitIndex = edit != null ? edit.unitIndex : widget.initialUnitIndex;
    _selectedUnitTitle = edit != null ? edit.unitTitle : widget.initialUnitTitle;

    _selectedColorIndex = edit?.colorIndex ?? 0;
    _selectedTag = edit?.tag ?? (hasExplicitInitialTag ? widget.initialTag! : '');

    if (edit != null) {
      if (edit.content.contains('KAVRAM KARŞILAŞTIRMASI') || edit.title.contains(' vs ') || edit.content.contains('【 Özellik:')) {
        _selectedTemplateType = NoteTemplateType.comparison;
        _initComparisonFromContent(edit.content);
      } else if (edit.content.contains('ATÖLYE') || edit.content.contains('İş Güvenliği') || edit.content.contains('【') || edit.content.contains('⬇️') || edit.content.contains('Uygulama Adımları')) {
        _selectedTemplateType = NoteTemplateType.workshop;
        _initWorkshopStepsFromContent(edit.content);
      } else {
        _selectedTemplateType = NoteTemplateType.general;
      }
    } else {
      // İlk not ekranı açıldığında varsayılan olarak Genel Not Şablonu seçili gelir
      _selectedTemplateType = widget.initialTemplateType ?? NoteTemplateType.general;
      
      // Eğer doğrudan spesifik bir şablon ile başlatılmışsa içeriği doldur
      if (_selectedTemplateType == NoteTemplateType.workshop) {
        _workshopSteps.add(_createWorkshopStep());
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = NoteTemplate.workshop.defaultTitle;
        }
        _selectedColorIndex = NoteTemplate.workshop.defaultColorIndex;
        if (!hasExplicitInitialTag) {
          _selectedTag = NoteTemplate.workshop.defaultTag;
        }
      } else if (_selectedTemplateType == NoteTemplateType.comparison) {
        _initComparisonFromContent('');
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = NoteTemplate.comparison.defaultTitle;
        }
        _selectedColorIndex = NoteTemplate.comparison.defaultColorIndex;
        if (!hasExplicitInitialTag) {
          _selectedTag = NoteTemplate.comparison.defaultTag;
        }
      } else if (_selectedTemplateType != NoteTemplateType.general) {
        final tpl = NoteTemplate.fromType(_selectedTemplateType);
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = tpl.defaultTitle;
        }
        if (_contentController.text.trim().isEmpty) {
          _contentController.text = tpl.defaultContent;
        }
        _selectedColorIndex = tpl.defaultColorIndex;
        if (!hasExplicitInitialTag) {
          _selectedTag = tpl.defaultTag;
        }
      }
    }
  }

  @override
  void dispose() {
    if (_isListening) {
      _commitSpeechToController(_activeListeningController);
      _speechService.cancelListening();
    }
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _disposeWorkshopSteps();
    _disposeComparison();
    super.dispose();
  }

  String _normalizeCourseId(String title, String grade) {
    if (title == 'Kat Hizmetleri Atölyesi') {
      return '${grade}_kat_hizmetleri_atolyesi';
    }
    switch (title) {
      case 'Ön Büro Hizmetleri Atölyesi': return 'on_buro_hizmetleri_atolyesi';
      case 'Ön Büroda Rezervasyon': return 'on_buro_rezervasyon';
      case 'Konuk Giriş Çıkış İşlemleri': return 'konuk_giris_cikis_islemleri';
      case 'Konaklama İşletmeciliği': return 'konaklama_isletmeciligi';
      case 'Sürdürülebilir Turizm': return 'surdurulebilir_turizm';
      case 'Alternatif Turizm': return 'alternatif_turizm';
      case 'Kuru Temizleme İşlemleri': return 'kuru_temizleme_islemleri';
      case 'Çamaşırhane İşlemleri': return 'camasirhane_islemleri';
      case 'Dünya Seyahat ve Turizm Coğrafyası': return 'dunya_seyahat_ve_turizm_cografyasi';
      case 'Dünya Kültürleri': return 'dunya_kulturleri';
      case 'Kongre ve Etkinlik Turizmi': return 'kongre_ve_etkinlik_turizmi';
      case 'Gastronomi Turizmi': return 'gastronomi_turizmi';
      case 'Tur Operasyonu': return 'tur_operasyonu';
      case 'Transfer Operasyonu': return 'transfer_operasyonu';
      case 'Sosyal Medya': return 'sosyal_medya';
      case 'Mesleki Gelişim Atölyesi': return 'mesleki_gelisim_atolyesi';
      case 'Genel Turizm': return 'genel_turizm';
      case 'Otelcilik ve Seyahat Hizmetleri': return 'otelcilik_ve_seyahat_hizmetleri';
      default:
        return title.toLowerCase()
            .replaceAll(' ', '_')
            .replaceAll('ö', 'o')
            .replaceAll('ü', 'u')
            .replaceAll('ı', 'i')
            .replaceAll('ş', 's')
            .replaceAll('ç', 'c')
            .replaceAll('ğ', 'g');
    }
  }

  bool _hasUserEditedContent() {
    if (_selectedTemplateType == NoteTemplateType.workshop) {
      return _workshopSteps.any((s) => s.contentController.text.trim().isNotEmpty);
    }
    if (_selectedTemplateType == NoteTemplateType.comparison) {
      final hasConcept = _comparisonConcepts.any((c) => c.text.trim().isNotEmpty);
      final hasFeature = _comparisonFeatures.any((f) =>
          f.featureTitleController.text.trim().isNotEmpty ||
          f.conceptValuesControllers.any((v) => v.text.trim().isNotEmpty));
      return hasConcept || hasFeature;
    }
    final text = _contentController.text.trim();
    if (text.isEmpty) return false;
    for (final t in NoteTemplate.templates) {
      if (text == t.defaultContent.trim()) return false;
    }
    return true;
  }

  void _onTemplateSelected(NoteTemplate template) {
    if (_selectedTemplateType == template.type) {
      if (_selectedTemplateType == NoteTemplateType.workshop && _workshopSteps.isNotEmpty) {
        return;
      }
      if (_selectedTemplateType == NoteTemplateType.comparison && _comparisonFeatures.isNotEmpty) {
        return;
      }
      if (_contentController.text.trim().isNotEmpty) {
        return;
      }
    }

    if (_hasUserEditedContent()) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: template.accentColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(template.iconEmoji, style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Şablon Değiştirilsin mi?',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mevcut notunuz "${template.title}" formatı ile güncellenecektir. Yazdığınız metin şablonla değiştirilsin mi?',
                style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: template.accentColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: template.accentColor.withValues(alpha: 0.25)),
                ),
                child: Row(
                  children: [
                    Icon(template.iconData, size: 20, color: template.accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        template.subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: template.accentColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Vazgeç',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: template.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              onPressed: () {
                Navigator.pop(ctx);
                _forceApplyTemplate(template);
              },
              child: Text(
                'Şablonu Uygula',
                style: GoogleFonts.inter(fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    } else {
      _forceApplyTemplate(template);
    }
  }

  void _forceApplyTemplate(NoteTemplate template) {
    setState(() {
      _selectedTemplateType = template.type;

      final currentTitle = _titleController.text.trim();
      final isGenericOrTemplateTitle = currentTitle.isEmpty ||
          NoteTemplate.templates.any((t) => t.defaultTitle == currentTitle);

      if (template.type != NoteTemplateType.general && isGenericOrTemplateTitle) {
        _titleController.text = template.defaultTitle;
      } else if (template.type == NoteTemplateType.general && isGenericOrTemplateTitle) {
        _titleController.clear();
      }

      if (template.type == NoteTemplateType.workshop) {
        _disposeWorkshopSteps();
        _workshopSteps.add(_createWorkshopStep());
      } else if (template.type == NoteTemplateType.comparison) {
        _disposeComparison();
        _initComparisonFromContent('');
      } else {
        _contentController.text = template.defaultContent;
      }

      _selectedColorIndex = template.defaultColorIndex;
      _selectedTag = template.defaultTag;
    });
  }

  void _insertContentSnippet(String snippet) {
    if (_selectedTemplateType == NoteTemplateType.workshop && _workshopSteps.isNotEmpty) {
      _WorkshopStepItem target = _workshopSteps.last;
      for (final s in _workshopSteps) {
        if (s.focusNode.hasFocus) {
          target = s;
          break;
        }
      }
      final ctrl = target.contentController;
      final text = ctrl.text;
      final selection = ctrl.selection;
      if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
        final newText = text.replaceRange(selection.start, selection.end, snippet);
        ctrl.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start + snippet.length),
        );
      } else {
        final newText = text.isEmpty ? snippet : '$text\n$snippet';
        ctrl.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
      return;
    }

    if (_selectedTemplateType == NoteTemplateType.comparison && _comparisonFeatures.isNotEmpty) {
      TextEditingController? targetCtrl;
      for (final f in _comparisonFeatures) {
        if (f.featureTitleController.selection.isValid && f.featureTitleController.selection.start >= 0) {
          targetCtrl = f.featureTitleController;
          break;
        }
        for (final ctrl in f.conceptValuesControllers) {
          if (ctrl.selection.isValid && ctrl.selection.start >= 0) {
            targetCtrl = ctrl;
            break;
          }
        }
        if (targetCtrl != null) break;
      }
      targetCtrl ??= _comparisonFeatures.last.conceptValuesControllers.first;
      final text = targetCtrl.text;
      final selection = targetCtrl.selection;
      if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
        final newText = text.replaceRange(selection.start, selection.end, snippet);
        targetCtrl.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: selection.start + snippet.length),
        );
      } else {
        final newText = text.isEmpty ? snippet : '$text\n$snippet';
        targetCtrl.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
      return;
    }

    final text = _contentController.text;
    final selection = _contentController.selection;
    if (selection.isValid && selection.start >= 0 && selection.end >= 0) {
      final newText = text.replaceRange(selection.start, selection.end, snippet);
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: selection.start + snippet.length),
      );
    } else {
      final newText = text.isEmpty ? snippet : '$text\n$snippet';
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    }
  }

  // ── Workshop Step Helper Methods ──
  _WorkshopStepItem _createWorkshopStep({String initialContent = ''}) {
    return _WorkshopStepItem(
      content: initialContent,
    );
  }

  void _initWorkshopStepsFromContent(String content) {
    _disposeWorkshopSteps();
    if (content.trim().isEmpty) {
      _workshopSteps.add(_createWorkshopStep());
      return;
    }

    if (content.contains('⬇️') || content.contains('【')) {
      final chunks = content.split('⬇️');
      for (final chunk in chunks) {
        final raw = chunk.trim();
        if (raw.isEmpty) continue;
        final body = raw.replaceAll(RegExp(r'【.*?】'), '').trim();
        _workshopSteps.add(_createWorkshopStep(initialContent: body));
      }
    } else {
      _workshopSteps.add(_createWorkshopStep(initialContent: content.trim()));
    }

    if (_workshopSteps.isEmpty) {
      _workshopSteps.add(_createWorkshopStep());
    }
  }

  void _disposeWorkshopSteps() {
    for (final step in _workshopSteps) {
      step.dispose();
    }
    _workshopSteps.clear();
  }

  void _addNewWorkshopStep() {
    setState(() {
      final newStep = _createWorkshopStep();
      _workshopSteps.add(newStep);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          newStep.focusNode.requestFocus();
        }
      });
    });
  }

  void _removeWorkshopStep(int index) {
    if (_workshopSteps.length <= 1) return;
    setState(() {
      final removed = _workshopSteps.removeAt(index);
      removed.dispose();
    });
  }

  String _getStepHint(int index) {
    return 'Yapılacak işlem adımını yazınız...';
  }

  Widget _buildWorkshopFlowEditor(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Adım Kutucukları Listesi
        ...List.generate(_workshopSteps.length, (index) {
          final step = _workshopSteps[index];
          final isLast = index == _workshopSteps.length - 1;

          return Column(
            children: [
              _buildStepCard(index, step, isWide),
              if (!isLast) _buildStepConnector(),
            ],
          );
        }),

        const SizedBox(height: 14),

        // + Adım Ekle Butonu
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _addNewWorkshopStep,
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 18,
                  vertical: isWide ? 14 : 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF059669),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF059669).withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF059669),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Uygulama Adımı Ekle',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 14.5 : 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF059669),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepCard(int index, _WorkshopStepItem step, bool isWide) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF059669).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withValues(alpha: 0.09),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF059669).withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Numara Rozeti
                Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(
                    color: Color(0xFF059669),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.playlist_add_check_rounded,
                  size: 20,
                  color: Color(0xFF059669),
                ),
                const SizedBox(width: 8),
                // Sabit ve Dinamik Adım Sırası Başlığı (Kullanıcı silmekle uğraşmaz)
                Expanded(
                  child: Text(
                    '${index + 1}. Adım',
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 15 : 14,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF065F46),
                    ),
                  ),
                ),
                // Sesle Yaz Butonu (Adım için)
                _buildSpeechDictationButton(
                  targetController: step.contentController,
                  isLargeScreen: isWide,
                  isCompact: true,
                ),
                const SizedBox(width: 6),
                // Sil Butonu (Birden fazla adım varsa)
                if (_workshopSteps.length > 1)
                  InkWell(
                    onTap: () => _removeWorkshopStep(index),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 17,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Not Giriş Alanı (İçerisi boş, tıklayınca içine yazılabilir)
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextFormField(
              controller: step.contentController,
              focusNode: step.focusNode,
              onTap: _onFieldTap,
              minLines: 3,
              maxLines: null,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                color: const Color(0xFF1E293B),
                height: 1.45,
              ),
              decoration: InputDecoration(
                hintText: _getStepHint(index),
                hintStyle: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: AppColors.textHint,
                  height: 1.4,
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF059669), width: 1.6),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.5,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF059669).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF059669).withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.arrow_downward_rounded,
                size: 18,
                color: Color(0xFF059669),
              ),
            ),
          ),
          Container(
            width: 2.5,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF059669).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  // ── Comparison Helper Methods ──
  void _initComparisonFromContent(String content) {
    _disposeComparison();

    if (content.contains('Kavramlar:') || content.contains('【 Özellik:')) {
      final lines = content.split('\n');
      final conceptNames = <String>[];
      for (final line in lines) {
        if (line.trim().startsWith('Kavramlar:')) {
          final rawNames = line.replaceFirst('Kavramlar:', '').split('➔');
          for (final n in rawNames) {
            final clean = n.trim();
            if (clean.isNotEmpty) conceptNames.add(clean);
          }
          break;
        }
      }

      for (final name in conceptNames) {
        _comparisonConcepts.add(TextEditingController(text: name));
      }

      final featureBlocks = content.split('⚖️');
      for (final block in featureBlocks) {
        final rawBlock = block.trim();
        if (!rawBlock.contains('【 Özellik:')) continue;
        final titleMatch = RegExp(r'【\s*Özellik:\s*(.*?)\s*】').firstMatch(rawBlock);
        final fTitle = titleMatch?.group(1)?.trim() ?? '';
        final values = <String>[];

        for (int c = 0; c < _comparisonConcepts.length; c++) {
          final cName = _comparisonConcepts[c].text.trim();
          final pattern = RegExp('•\\s*${RegExp.escape(cName)}:\\s*(.*)');
          final valMatch = pattern.firstMatch(rawBlock);
          final val = valMatch?.group(1)?.trim() ?? '';
          values.add(val == '-' ? '' : val);
        }

        _comparisonFeatures.add(_ComparisonFeatureItem(
          title: fTitle,
          conceptCount: _comparisonConcepts.length,
          initialValues: values,
        ));
      }
    }

    if (_comparisonConcepts.isEmpty) {
      _comparisonConcepts.add(TextEditingController());
      _comparisonConcepts.add(TextEditingController());
    }
    if (_comparisonFeatures.isEmpty) {
      _comparisonFeatures.add(_ComparisonFeatureItem(conceptCount: _comparisonConcepts.length));
    }
  }

  void _disposeComparison() {
    for (final c in _comparisonConcepts) {
      c.dispose();
    }
    _comparisonConcepts.clear();
    for (final f in _comparisonFeatures) {
      f.dispose();
    }
    _comparisonFeatures.clear();
  }

  void _addComparisonConcept() {
    if (_comparisonConcepts.length >= 6) return;
    setState(() {
      _comparisonConcepts.add(TextEditingController());
      for (final feat in _comparisonFeatures) {
        feat.addConcept();
      }
    });
  }

  void _removeComparisonConcept(int index) {
    if (_comparisonConcepts.length <= 2) return;
    setState(() {
      final removed = _comparisonConcepts.removeAt(index);
      removed.dispose();
      for (final feat in _comparisonFeatures) {
        feat.removeConceptAt(index);
      }
    });
  }

  void _addComparisonFeature() {
    setState(() {
      final newFeat = _ComparisonFeatureItem(conceptCount: _comparisonConcepts.length);
      _comparisonFeatures.add(newFeat);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) newFeat.focusNode.requestFocus();
      });
    });
  }

  void _removeComparisonFeature(int index) {
    if (_comparisonFeatures.length <= 1) return;
    setState(() {
      final removed = _comparisonFeatures.removeAt(index);
      removed.dispose();
    });
  }

  Widget _buildComparisonFlowEditor(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Yan Yana Karşılaştırılacak Kavramlar Barı
        _buildComparisonConceptsBar(isWide),

        const SizedBox(height: 16),

        // 2. Karşılaştırma Özellikleri Başlığı
        Row(
          children: [
            const Icon(Icons.tune_rounded, size: 16, color: Color(0xFF0284C7)),
            const SizedBox(width: 6),
            Text(
              'Karşılaştırma Özellikleri & Kriterleri',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0369A1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Özellik Kartları Listesi (Adım falan yazmaz!)
        ...List.generate(_comparisonFeatures.length, (index) {
          final feature = _comparisonFeatures[index];
          final isLast = index == _comparisonFeatures.length - 1;

          return Column(
            children: [
              _buildComparisonFeatureCard(index, feature, isWide),
              if (!isLast) _buildComparisonConnector(),
            ],
          );
        }),

        const SizedBox(height: 14),

        // + Karşılaştırma Özelliği Ekle Butonu
        Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _addComparisonFeature,
              borderRadius: BorderRadius.circular(14),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 24 : 18,
                  vertical: isWide ? 14 : 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF0284C7),
                    width: 1.6,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Karşılaştırma Özelliği Ekle',
                      style: GoogleFonts.outfit(
                        fontSize: isWide ? 14.5 : 13.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonConceptsBar(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.compare_arrows_rounded, size: isWide ? 19 : 17, color: const Color(0xFF0284C7)),
            const SizedBox(width: 7),
            Text(
              'Karşılaştırılacak Kavramlar (${_comparisonConcepts.length}/6)',
              style: GoogleFonts.outfit(
                fontSize: isWide ? 15.5 : 13.5,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0369A1),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < _comparisonConcepts.length; i++) ...[
                _buildConceptHeaderCard(i, isWide),
                if (i < _comparisonConcepts.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Container(
                      padding: const EdgeInsets.all(5.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.balance_rounded,
                        size: 15,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
              ],
              if (_comparisonConcepts.length < 6) ...[
                const SizedBox(width: 10),
                _buildAddConceptCard(isWide),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConceptHeaderCard(int index, bool isWide) {
    final canDelete = _comparisonConcepts.length > 2;
    final conceptColor = ComparisonColors.getColor(index);
    return Container(
      width: isWide ? 220 : 175,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: conceptColor,
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: conceptColor.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: conceptColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}. Kavram',
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 12 : 11,
                    fontWeight: FontWeight.w800,
                    color: conceptColor,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSpeechDictationButton(
                    targetController: _comparisonConcepts[index],
                    isLargeScreen: isWide,
                    isCompact: true,
                  ),
                  if (canDelete) ...[
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => _removeComparisonConcept(index),
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        padding: const EdgeInsets.all(3.5),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _comparisonConcepts[index],
            onTap: _onFieldTap,
            style: GoogleFonts.outfit(
              fontSize: isWide ? 15 : 13.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: index == 0
                  ? 'Örn: Otel'
                  : index == 1
                      ? 'Örn: Tatil Köyü'
                      : index == 2
                          ? 'Örn: Butik Otel'
                          : '${index + 1}. Kavram',
              hintStyle: GoogleFonts.outfit(
                fontSize: isWide ? 13.5 : 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textHint,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: conceptColor, width: 1.8),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildAddConceptCard(bool isWide) {
    return InkWell(
      onTap: _addComparisonConcept,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: isWide ? 135 : 110,
        height: 78,
        decoration: BoxDecoration(
          color: const Color(0xFF0284C7).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF0284C7).withValues(alpha: 0.35),
            width: 1.4,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_circle_outline_rounded, color: const Color(0xFF0284C7), size: isWide ? 22 : 20),
              const SizedBox(height: 5),
              Text(
                '+ Kavram Ekle',
                style: GoogleFonts.outfit(
                  fontSize: isWide ? 12.5 : 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComparisonFeatureCard(int fIndex, _ComparisonFeatureItem feature, bool isWide) {
    final canDelete = _comparisonFeatures.length > 1;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0284C7).withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Başlık Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.18),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0284C7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.balance_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${fIndex + 1}. Özellik:',
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 16 : 14,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0369A1),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: feature.featureTitleController,
                    focusNode: feature.focusNode,
                    onTap: _onFieldTap,
                    style: GoogleFonts.outfit(
                      fontSize: isWide ? 16 : 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Karşılaştırılacak özellik / kriteri yazınız (Örn: Hizmet Konsepti)',
                      hintStyle: GoogleFonts.outfit(
                        fontSize: isWide ? 14 : 12.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _buildSpeechDictationButton(
                  targetController: feature.featureTitleController,
                  isLargeScreen: isWide,
                  isCompact: true,
                ),
                if (canDelete) ...[
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () => _removeComparisonFeature(fIndex),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Her Bir Kavram İçin Karşılaştırma Değer Alanları
          Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final conceptCount = _comparisonConcepts.length;
                if (conceptCount == 2 && constraints.maxWidth >= 380) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildConceptValueField(fIndex, 0, feature, isWide)),
                      const SizedBox(width: 10),
                      Expanded(child: _buildConceptValueField(fIndex, 1, feature, isWide)),
                    ],
                  );
                }
                final minBoxWidth = isWide ? 220.0 : 175.0;
                final totalWidthNeeded = (conceptCount * minBoxWidth) + ((conceptCount - 1) * 10);
                final canFitAllInRow = constraints.maxWidth >= totalWidthNeeded;

                if (canFitAllInRow) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int c = 0; c < conceptCount; c++) ...[
                        Expanded(
                          child: _buildConceptValueField(fIndex, c, feature, isWide),
                        ),
                        if (c < conceptCount - 1) const SizedBox(width: 10),
                      ],
                    ],
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (int c = 0; c < conceptCount; c++) ...[
                        SizedBox(
                          width: minBoxWidth,
                          child: _buildConceptValueField(fIndex, c, feature, isWide),
                        ),
                        if (c < conceptCount - 1) const SizedBox(width: 10),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConceptValueField(int fIndex, int cIndex, _ComparisonFeatureItem feature, bool isWide) {
    while (feature.conceptValuesControllers.length <= cIndex) {
      feature.addConcept();
    }
    final ctrl = feature.conceptValuesControllers[cIndex];
    final rawName = cIndex < _comparisonConcepts.length ? _comparisonConcepts[cIndex].text.trim() : '';
    final displayName = rawName.isNotEmpty ? rawName : '${cIndex + 1}. Kavram';
    final conceptColor = ComparisonColors.getColor(cIndex);

    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: conceptColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: conceptColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: conceptColor.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: conceptColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: isWide ? 14 : 12.5,
                    fontWeight: FontWeight.w800,
                    color: conceptColor,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _buildSpeechDictationButton(
                targetController: ctrl,
                isLargeScreen: isWide,
                isCompact: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: ctrl,
            onTap: _onFieldTap,
            minLines: 3,
            maxLines: null,
            style: GoogleFonts.inter(
              fontSize: isWide ? 14.5 : 13,
              color: const Color(0xFF1E293B),
              height: 1.45,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: '$displayName için bu özelliği yazınız...',
              hintStyle: GoogleFonts.inter(
                fontSize: isWide ? 13 : 11.5,
                color: AppColors.textHint,
                height: 1.35,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(11),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: conceptColor, width: 1.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 2.5,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.balance_rounded,
                size: 16,
                color: Color(0xFF0284C7),
              ),
            ),
          ),
          Container(
            width: 2.5,
            height: 10,
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInsertChip(String label, String snippet, {bool isLargeScreen = false}) {
    return Padding(
      padding: EdgeInsets.only(right: isLargeScreen ? 8 : 6),
      child: InkWell(
        onTap: () => _insertContentSnippet(snippet),
        borderRadius: BorderRadius.circular(isLargeScreen ? 10 : 8),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLargeScreen ? 11 : 8,
            vertical: isLargeScreen ? 6 : 4,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(isLargeScreen ? 10 : 8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isLargeScreen ? 12.5 : 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleSpeechDictation(TextEditingController controller) async {
    if (_isListening) {
      final wasThisActive = _activeListeningController == controller;
      await _speechService.stopListening();
      if (mounted) {
        setState(() {
          _commitSpeechToController(controller);
          _isListening = false;
          _activeListeningController = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎤 Sesli dikte tamamlandı. Not içeriğine eklendi.'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (!wasThisActive) {
        _startListeningOn(controller);
      }
    } else {
      _startListeningOn(controller);
    }
  }

  void _commitSpeechToController(TextEditingController? controller) {
    _speechPrefixText = '';
    _speechSuffixText = '';
  }

  Future<void> _startListeningOn(TextEditingController controller) async {
    // Tıklanan imleç konumuna göre mevcut metni ön ve arka kısım olarak sabitle
    final currentText = controller.text;
    final selection = controller.selection;
    int insertOffset = (selection.isValid && selection.baseOffset >= 0 && selection.baseOffset <= currentText.length)
        ? selection.baseOffset
        : currentText.length;

    _speechPrefixText = currentText.substring(0, insertOffset);
    _speechSuffixText = currentText.substring(insertOffset);
    _activeListeningController = controller;

    final started = await _speechService.startListening(
      onResult: (text, isFinal) {
        if (!mounted || _activeListeningController != controller) return;
        final incoming = text.trim();
        if (incoming.isEmpty) return;

        setState(() {
          // Mevcut metne dokunmadan, imlecin olduğu noktaya yeni metni ekle
          final prefix = _speechPrefixText;
          final suffix = _speechSuffixText;
          final sepBefore = (prefix.isNotEmpty && !prefix.endsWith(' ') && !prefix.endsWith('\n')) ? ' ' : '';
          final sepAfter = (suffix.isNotEmpty && !suffix.startsWith(' ') && !suffix.startsWith('\n')) ? ' ' : '';
          final fullText = '$prefix$sepBefore$incoming$sepAfter$suffix';
          
          controller.text = fullText;
          final newOffset = prefix.length + sepBefore.length + incoming.length;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newOffset),
          );
        });
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _commitSpeechToController(_activeListeningController);
          _isListening = false;
          _activeListeningController = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onStatusChange: (status) {
        if (!mounted) return;
        if (status == 'done' || status == 'notListening') {
          setState(() {
            _commitSpeechToController(_activeListeningController);
            _isListening = false;
            _activeListeningController = null;
          });
        }
      },
    );

    if (mounted) {
      setState(() {
        _isListening = started;
        if (!started) _activeListeningController = null;
      });
    }
  }

  void _onFieldTap() {
    if (_isListening) {
      _speechService.cancelListening();
      if (mounted) {
        setState(() {
          _commitSpeechToController(_activeListeningController);
          _isListening = false;
          _activeListeningController = null;
        });
      }
    }
  }

  Widget _buildSpeechDictationButton({
    required TextEditingController targetController,
    required bool isLargeScreen,
    bool isCompact = false,
  }) {
    final isTargetActive = _isListening && _activeListeningController == targetController;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _toggleSpeechDictation(targetController),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 8 : (isLargeScreen ? 14 : 10),
            vertical: isCompact ? 5 : (isLargeScreen ? 8 : 6),
          ),
          decoration: BoxDecoration(
            color: isTargetActive
                ? const Color(0xFFEF4444)
                : const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isTargetActive
                  ? const Color(0xFFDC2626)
                  : const Color(0xFFC7D2FE),
              width: isTargetActive ? 1.8 : 1.2,
            ),
            boxShadow: isTargetActive
                ? [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.45),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isTargetActive ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                size: isLargeScreen ? 18 : 16,
                color: isTargetActive ? Colors.white : const Color(0xFF4F46E5),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 6),
                Text(
                  isTargetActive ? 'Durdur (Dinleniyor...)' : 'Sesle Yaz',
                  style: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 12.5 : 11.5,
                    fontWeight: FontWeight.w700,
                    color: isTargetActive ? Colors.white : const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showTemplateSelectorModal() {
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isLargeScreen = screenWidth >= 1000;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: screenHeight * (isLargeScreen ? 0.92 : 0.85),
            maxWidth: isLargeScreen ? (screenWidth * 0.94).clamp(900.0, 1280.0) : 640,
          ),
          margin: EdgeInsets.only(
            left: isLargeScreen ? 32 : (screenWidth >= 768 ? 40 : 0),
            right: isLargeScreen ? 32 : (screenWidth >= 768 ? 40 : 0),
            bottom: 0,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 30,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Üst Sürükleme Çubuğu
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Not Şablonları Rehberi',
                            style: GoogleFonts.outfit(
                              fontSize: isLargeScreen ? 20 : 18.5,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Dersine en uygun profesyonel formatı seçerek hızlı ve düzenli not tutabilirsin',
                            style: GoogleFonts.inter(
                              fontSize: isLargeScreen ? 13 : 12,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),

              // ── Büyük Ekran: 3 Şablon Yan Yana (Aşağı Kaydırmaya Gerek Kalmaz) ──
              if (isLargeScreen)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: NoteTemplate.templates.map((tpl) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: _buildTemplateGuideCard(
                              tpl,
                              isLargeScreen: true,
                              onSelect: () {
                                Navigator.pop(ctx);
                                _onTemplateSelected(tpl);
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                )
              // ── Mobil (Android & iOS): Dikey Kaydırılabilir Liste ──
              else
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: NoteTemplate.templates.map((tpl) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildTemplateGuideCard(
                          tpl,
                          isLargeScreen: false,
                          onSelect: () {
                            Navigator.pop(ctx);
                            _onTemplateSelected(tpl);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTemplateGuideCard(
    NoteTemplate tpl, {
    required bool isLargeScreen,
    required VoidCallback onSelect,
  }) {
    final isSelected = _selectedTemplateType == tpl.type;

    final String usageSummary;
    if (tpl.type == NoteTemplateType.general) {
      usageSummary = '• Serbest formatta ders notu ve sınav özeti çıkarma\n• Hızlı ekle çubuğu (Madde, İSG, Dikkat, İpucu, Fark)\n• Sağ alttaki mikrofonla Türkçe sesli dikte desteği';
    } else if (tpl.type == NoteTemplateType.comparison) {
      usageSummary = '• "+ Kavram Ekle" ile 2\'den 6\'ya kadar kavram kıyaslama\n• Her kavrama özel 6 ayırt edici renkli kutucuk\n• "+ Karşılaştırma Özelliği Ekle" ile kriter belirleme\n• Şekilsel karşılaştırma tablosu ile okuma kolaylığı';
    } else {
      usageSummary = '• "+ Adım Ekle" ile işlem adımlarını sırayla listeleme\n• Her adım için bağımsız sesle yazma mikrofonu\n• Atölye, servis ve operasyon standartları akışı';
    }

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? tpl.accentColor.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? tpl.accentColor : const Color(0xFFE2E8F0),
          width: isSelected ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? tpl.accentColor.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: isSelected ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(isLargeScreen ? 14 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: tpl.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(tpl.iconEmoji, style: TextStyle(fontSize: isLargeScreen ? 22 : 24)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tpl.title,
                          style: GoogleFonts.outfit(
                            fontSize: isLargeScreen ? 14.5 : 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: tpl.accentColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            tpl.badgeTitle,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: tpl.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                tpl.subtitle,
                style: GoogleFonts.inter(
                  fontSize: isLargeScreen ? 11.5 : 12.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  usageSummary,
                  style: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 11 : 12,
                    height: 1.45,
                    color: const Color(0xFF334155),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? tpl.accentColor : Colors.white,
                  foregroundColor: isSelected ? Colors.white : tpl.accentColor,
                  side: BorderSide(color: tpl.accentColor, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 9 : 11),
                  elevation: isSelected ? 2 : 0,
                ),
                onPressed: onSelect,
                icon: Icon(
                  isSelected ? Icons.check_circle_rounded : tpl.iconData,
                  size: isLargeScreen ? 16 : 18,
                ),
                label: Text(
                  isSelected ? 'Seçili Şablon ✓' : 'Bu Şablonu Kullan',
                  style: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 12 : 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateSelectorSection(Color themeBorderColor, bool isWide, {bool isLargeScreen = false}) {
    final activeTemplate = NoteTemplate.fromType(_selectedTemplateType);

    return Container(
      padding: EdgeInsets.all(isLargeScreen ? 16 : 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: activeTemplate.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: activeTemplate.accentColor.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          activeTemplate.iconEmoji,
                          style: TextStyle(fontSize: isLargeScreen ? 14 : 12),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          activeTemplate.shortTitle,
                          style: GoogleFonts.outfit(
                            fontSize: isLargeScreen ? 13 : 12,
                            fontWeight: FontWeight.w800,
                            color: activeTemplate.accentColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: _showTemplateSelectorModal,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Şablon Rehberi',
                        style: GoogleFonts.inter(
                          fontSize: isLargeScreen ? 12.5 : 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info_outline_rounded,
                        size: isLargeScreen ? 16 : 14,
                        color: const Color(0xFF4F46E5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 3 Şablon Kartı Butonu (Eşit Yükseklik ve Taşmayan Metinler)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: NoteTemplate.templates.map((tpl) {
                final isSelected = _selectedTemplateType == tpl.type;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onTemplateSelected(tpl),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.symmetric(
                            vertical: isLargeScreen ? 14 : (isWide ? 13 : 10),
                            horizontal: isLargeScreen ? 8 : (isWide ? 6 : 4),
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? tpl.accentColor.withValues(alpha: 0.08)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? tpl.accentColor : const Color(0xFFCBD5E1),
                              width: isSelected ? 2.2 : 1.0,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: tpl.accentColor.withValues(alpha: 0.22),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.02),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    tpl.iconEmoji,
                                    style: TextStyle(fontSize: isLargeScreen ? 22 : (isWide ? 20 : 18)),
                                  ),
                                  if (isSelected) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.check_circle_rounded,
                                      size: isLargeScreen ? 16 : (isWide ? 15 : 13),
                                      color: tpl.accentColor,
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                tpl.shortTitle,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                style: GoogleFonts.outfit(
                                   fontSize: isLargeScreen ? 14 : (isWide ? 12.5 : 11.5),
                                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
                                  color: isSelected ? tpl.accentColor : AppColors.textPrimary,
                                  height: 1.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    if (_isListening) {
      _commitSpeechToController(_activeListeningController);
      _speechService.stopListening();
      _isListening = false;
      _activeListeningController = null;
    }
    if (!_formKey.currentState!.validate()) return;

    final String finalContent;
    if (_selectedTemplateType == NoteTemplateType.workshop) {
      final buffer = StringBuffer();
      for (int i = 0; i < _workshopSteps.length; i++) {
        final step = _workshopSteps[i];
        final stepTitle = '${i + 1}. Adım';
        final stepBody = step.contentController.text.trim();

        buffer.writeln('【 $stepTitle 】');
        if (stepBody.isNotEmpty) {
          buffer.writeln(stepBody);
        }
        if (i < _workshopSteps.length - 1) {
          buffer.writeln('\n         ⬇️\n');
        }
      }
      finalContent = buffer.toString().trim();
      if (finalContent.isEmpty || !_workshopSteps.any((s) => s.contentController.text.trim().isNotEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen en az bir uygulama adımına not yazın.')),
        );
        return;
      }
    } else if (_selectedTemplateType == NoteTemplateType.comparison) {
      final buffer = StringBuffer();
      final conceptNames = _comparisonConcepts.asMap().entries.map((e) {
        final val = e.value.text.trim();
        return val.isNotEmpty ? val : 'Kavram ${e.key + 1}';
      }).toList();

      buffer.writeln('⚖️ KAVRAM KARŞILAŞTIRMASI');
      buffer.writeln('Kavramlar: ${conceptNames.join(' ➔ ')}');
      buffer.writeln();

      for (int i = 0; i < _comparisonFeatures.length; i++) {
        final feat = _comparisonFeatures[i];
        final featTitle = feat.featureTitleController.text.trim().isNotEmpty
            ? feat.featureTitleController.text.trim()
            : '${i + 1}. Özellik';

        buffer.writeln('【 Özellik: $featTitle 】');
        for (int c = 0; c < conceptNames.length; c++) {
          final cName = conceptNames[c];
          final cVal = c < feat.conceptValuesControllers.length
              ? feat.conceptValuesControllers[c].text.trim()
              : '';
          buffer.writeln('• $cName: ${cVal.isNotEmpty ? cVal : '-'}');
        }
        if (i < _comparisonFeatures.length - 1) {
          buffer.writeln('\n         ⚖️\n');
        }
      }
      finalContent = buffer.toString().trim();
      final hasAnyContent = _comparisonConcepts.any((c) => c.text.trim().isNotEmpty) ||
          _comparisonFeatures.any((f) =>
              f.featureTitleController.text.trim().isNotEmpty ||
              f.conceptValuesControllers.any((v) => v.text.trim().isNotEmpty));
      if (!hasAnyContent) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen karşılaştırma için en az bir kavram veya özellik doldurun.')),
        );
        return;
      }
    } else {
      finalContent = _contentController.text.trim();
      if (finalContent.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen not içeriğini boş bırakmayın')),
        );
        return;
      }
    }

    final isEditing = widget.noteToEdit != null;
    final now = DateTime.now();

    final note = CourseNoteModel(
      id: isEditing ? widget.noteToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(),
      grade: _selectedGrade,
      courseId: _selectedCourseId,
      courseTitle: _selectedCourseTitle,
      unitIndex: _selectedUnitIndex,
      unitTitle: _selectedUnitTitle,
      title: _titleController.text.trim(),
      content: finalContent,
      colorIndex: _selectedColorIndex,
      tag: _selectedTag,
      createdAt: isEditing ? widget.noteToEdit!.createdAt : now,
      updatedAt: now,
    );

    final navigator = Navigator.of(context);
    final parentContext = navigator.context;

    if (isEditing) {
      ref.read(notesProvider.notifier).updateNote(note);
    } else {
      ref.read(notesProvider.notifier).addNote(note);
      // Öğrenciye 5 puan kazandır
      ref.read(pointsProvider.notifier).addPoints(5);
      // Not Ustası rozeti için sayaç artır
      ref.read(badgeProgressProvider.notifier).incrementNotesCreated();
    }

    navigator.pop();

    if (!isEditing && parentContext.mounted) {
      showFloatingPointsAnimation(parentContext, points: 5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteToEdit != null;
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isLargeScreen = screenWidth >= 1024;
    final isWide = screenWidth >= 768;

    // Seçili sınıfa ait dersleri al
    final coursesForGrade = ref.watch(coursesProvider(_selectedGrade));

    // Seçili dersi bul
    Course? currentCourse;
    try {
      currentCourse = coursesForGrade.firstWhere(
        (c) => _normalizeCourseId(c.title, _selectedGrade) == _selectedCourseId,
        orElse: () => coursesForGrade.first,
      );
    } catch (_) {
      if (coursesForGrade.isNotEmpty) {
        currentCourse = coursesForGrade.first;
      }
    }

    final units = currentCourse?.learningUnits ?? [];

    final themeBorderColor = NoteColors.borderColors[_selectedColorIndex];
    final themeBgColor = NoteColors.bgColors[_selectedColorIndex];
    final activeTemplate = NoteTemplate.fromType(_selectedTemplateType);

    final double dialogMaxWidth;
    if (_isExpanded) {
      dialogMaxWidth = screenWidth * 0.98;
    } else if (isLargeScreen) {
      // PC, akıllı tahta ve büyük monitörler için ekranı yatay olarak geniş ve ferah kullan
      dialogMaxWidth = (screenWidth * 0.96).clamp(1000.0, 1850.0);
    } else if (isWide) {
      dialogMaxWidth = (screenWidth * 0.95).clamp(720.0, 1050.0);
    } else {
      dialogMaxWidth = screenWidth;
    }

    // ── MOBİL / TELEFON (isWide == false): Pürüzsüz Klavye ve Tam Ekran Deneyimi ──
    if (!isWide) {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
              children: [
                // ── Sabit Üst Başlık Şeridi ──
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: themeBgColor,
                    border: Border(
                      bottom: BorderSide(
                        color: themeBorderColor.withValues(alpha: 0.3),
                        width: 1.2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: themeBorderColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isEditing ? Icons.edit_note_rounded : Icons.note_add_rounded,
                          color: themeBorderColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEditing ? 'Notu Düzenle' : 'Yeni Not Ekle',
                              style: GoogleFonts.outfit(
                                fontSize: 19.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$_selectedGrade. Sınıf • $_selectedCourseTitle',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Kapat',
                        icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // ── Kaydırılabilir Form Alanı (Klavye açıldığında takılmadan ve anında kayar) ──
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: _buildMobileLayout(
                        coursesForGrade: coursesForGrade,
                        units: units,
                        themeBorderColor: themeBorderColor,
                        isWide: isWide,
                        isEditing: isEditing,
                        activeTemplate: activeTemplate,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetAnimationDuration: Duration.zero,
      insetAnimationCurve: Curves.linear,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isLargeScreen ? 14 : 20,
        vertical: isLargeScreen ? 14 : 18,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: dialogMaxWidth,
            maxHeight: screenHeight * 0.96,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.16),
                  blurRadius: 28,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Üst Başlık Şeridi ──
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isLargeScreen ? 24 : 22,
                        vertical: isLargeScreen ? 18 : 16,
                      ),
                      decoration: BoxDecoration(
                        color: themeBgColor,
                        border: Border(
                          bottom: BorderSide(
                            color: themeBorderColor.withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isLargeScreen ? 10 : 8),
                            decoration: BoxDecoration(
                              color: themeBorderColor.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isEditing ? Icons.edit_note_rounded : Icons.note_add_rounded,
                              color: themeBorderColor,
                              size: isLargeScreen ? 28 : 24,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isEditing ? 'Notu Düzenle' : 'Yeni Not Ekle',
                                  style: GoogleFonts.outfit(
                                    fontSize: isLargeScreen ? 24 : 20.5,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  '$_selectedGrade. Sınıf • $_selectedCourseTitle',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: isLargeScreen ? 14.5 : 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (isLargeScreen)
                            IconButton(
                              tooltip: _isExpanded ? 'Standart Genişlik' : 'Tam Ekran Genişlet',
                              icon: Icon(
                                _isExpanded ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded,
                                color: AppColors.textSecondary,
                                size: 26,
                              ),
                              onPressed: () => setState(() => _isExpanded = !_isExpanded),
                            ),
                          IconButton(
                            tooltip: 'Kapat',
                            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // ── Form Alanı ──
                    Padding(
                      padding: EdgeInsets.all(isLargeScreen ? 24.0 : 22.0),
                      child: Form(
                        key: _formKey,
                        child: isLargeScreen
                            ? _buildLargeScreenLayout(
                                coursesForGrade: coursesForGrade,
                                units: units,
                                themeBorderColor: themeBorderColor,
                                isWide: isWide,
                                isEditing: isEditing,
                                activeTemplate: activeTemplate,
                              )
                            : _buildMobileLayout(
                                coursesForGrade: coursesForGrade,
                                units: units,
                                themeBorderColor: themeBorderColor,
                                isWide: isWide,
                                isEditing: isEditing,
                                activeTemplate: activeTemplate,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Büyük Ekran / Akıllı Tahta 2 Sütunlu Yatay Düzen ──
  Widget _buildLargeScreenLayout({
    required List<Course> coursesForGrade,
    required List units,
    required Color themeBorderColor,
    required bool isWide,
    required bool isEditing,
    required NoteTemplate activeTemplate,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── SOL SÜTUN: Şablon Seçici (Yalnızca Yeni Notta), Not Başlığı & İçerik Alanı (Geniş Panel) ──
        Expanded(
          flex: 68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isEditing) ...[
                _buildTemplateSelectorSection(themeBorderColor, isWide, isLargeScreen: true),
                const SizedBox(height: 16),
              ],
              _buildTitleField(isLargeScreen: true, activeTemplate: activeTemplate),
              const SizedBox(height: 16),
              _buildContentField(isLargeScreen: true, activeTemplate: activeTemplate, isWide: isWide),
            ],
          ),
        ),

        const SizedBox(width: 22),

        // ── SAĞ SÜTUN: Birim, Renk, Etiket ve Kaydet Paneli (Sabit & Hızlı Erişim) ──
        Expanded(
          flex: 32,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.initialCourseId == null) ...[
                  _buildGradeAndCourseSelectors(coursesForGrade: coursesForGrade, isLargeScreen: true),
                  const SizedBox(height: 14),
                ],
                _buildLearningUnitDropdown(units: units, isLargeScreen: true),
                const SizedBox(height: 16),
                _buildColorPicker(isLargeScreen: true, themeBorderColor: themeBorderColor),
                const SizedBox(height: 16),
                _buildTagChips(isLargeScreen: true, themeBorderColor: themeBorderColor),
                const SizedBox(height: 16),
                _buildRewardInfoBanner(isLargeScreen: true),
                const SizedBox(height: 22),
                _buildActionButtons(isLargeScreen: true, themeBorderColor: themeBorderColor, isEditing: isEditing),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobil / Dar Ekran Tek Sütunlu Düzen ──
  Widget _buildMobileLayout({
    required List<Course> coursesForGrade,
    required List units,
    required Color themeBorderColor,
    required bool isWide,
    required bool isEditing,
    required NoteTemplate activeTemplate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.initialCourseId == null) ...[
          _buildGradeAndCourseSelectors(coursesForGrade: coursesForGrade, isLargeScreen: false),
          const SizedBox(height: 14),
        ],
        _buildLearningUnitDropdown(units: units, isLargeScreen: false),
        const SizedBox(height: 16),
        if (!isEditing) ...[
          _buildTemplateSelectorSection(themeBorderColor, isWide, isLargeScreen: false),
          const SizedBox(height: 18),
        ],
        _buildTitleField(isLargeScreen: false, activeTemplate: activeTemplate),
        const SizedBox(height: 16),
        _buildContentField(isLargeScreen: false, activeTemplate: activeTemplate, isWide: isWide),
        const SizedBox(height: 16),
        _buildMobileColorAndTagRow(themeBorderColor),
        const SizedBox(height: 20),
        _buildActionButtons(isLargeScreen: false, themeBorderColor: themeBorderColor, isEditing: isEditing),
      ],
    );
  }

  Widget _buildGradeAndCourseSelectors({required List<Course> coursesForGrade, required bool isLargeScreen}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ders ve Sınıf',
          style: GoogleFonts.inter(
            fontSize: isLargeScreen ? 15 : 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedGrade,
                  items: [
                    DropdownMenuItem(value: '9', child: Text('9. Sınıf', style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600))),
                    DropdownMenuItem(value: '10', child: Text('10. Sınıf', style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600))),
                    DropdownMenuItem(value: '11', child: Text('11. Sınıf', style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600))),
                    DropdownMenuItem(value: '12', child: Text('12. Sınıf', style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600))),
                  ],
                  onChanged: (newGrade) {
                    if (newGrade == null) return;
                    final newCourses = ref.read(coursesProvider(newGrade));
                    setState(() {
                      _selectedGrade = newGrade;
                      if (newCourses.isNotEmpty) {
                        _selectedCourseTitle = newCourses.first.title;
                        _selectedCourseId = _normalizeCourseId(newCourses.first.title, newGrade);
                        _selectedUnitIndex = null;
                        _selectedUnitTitle = null;
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: coursesForGrade.any((c) => _normalizeCourseId(c.title, _selectedGrade) == _selectedCourseId)
                        ? _selectedCourseId
                        : (coursesForGrade.isNotEmpty ? _normalizeCourseId(coursesForGrade.first.title, _selectedGrade) : null),
                    items: coursesForGrade.map((course) {
                      final id = _normalizeCourseId(course.title, _selectedGrade);
                      return DropdownMenuItem<String>(
                        value: id,
                        child: Text(
                          course.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (newId) {
                      if (newId == null) return;
                      final match = coursesForGrade.firstWhere(
                        (c) => _normalizeCourseId(c.title, _selectedGrade) == newId,
                      );
                      setState(() {
                        _selectedCourseId = newId;
                        _selectedCourseTitle = match.title;
                        _selectedUnitIndex = null;
                        _selectedUnitTitle = null;
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLearningUnitDropdown({required List units, required bool isLargeScreen}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Öğrenme Birimi (İsteğe Bağlı)',
          style: GoogleFonts.inter(
            fontSize: isLargeScreen ? 15 : 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isLargeScreen ? Colors.white : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isLargeScreen ? const Color(0xFFCBD5E1) : AppColors.divider),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int?>(
              isExpanded: true,
              value: _selectedUnitIndex,
              hint: Text(
                'Dersin Geneli (Öğrenme Birimi Seçilmedi)',
                style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, color: AppColors.textHint),
              ),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(
                    '📌 Genel Ders Notu',
                    style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w600),
                  ),
                ),
                ...List.generate(units.length, (idx) {
                  final unit = units[idx];
                  return DropdownMenuItem<int?>(
                    value: idx,
                    child: Text(
                      '${idx + 1}. Birim: ${unit.title}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: isLargeScreen ? 14.5 : 13, fontWeight: FontWeight.w500),
                    ),
                  );
                }),
              ],
              onChanged: (newIdx) {
                setState(() {
                  _selectedUnitIndex = newIdx;
                  if (newIdx != null && newIdx < units.length) {
                    _selectedUnitTitle = '${newIdx + 1}. Birim: ${units[newIdx].title}';
                  } else {
                    _selectedUnitTitle = null;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField({required bool isLargeScreen, required NoteTemplate activeTemplate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Not Başlığı',
              style: GoogleFonts.inter(
                fontSize: isLargeScreen ? 15 : 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            if (_selectedTemplateType != NoteTemplateType.general)
              Text(
                '${activeTemplate.shortTitle} Formatı',
                style: GoogleFonts.inter(
                  fontSize: isLargeScreen ? 13 : 11.5,
                  fontWeight: FontWeight.w600,
                  color: activeTemplate.accentColor,
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                onTap: _onFieldTap,
                style: GoogleFonts.outfit(
                  fontSize: isLargeScreen ? 18.5 : 16.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  hintText: _selectedTemplateType == NoteTemplateType.comparison
                      ? 'Örn: Otel vs Tatil Köyü Farkları'
                      : (_selectedTemplateType == NoteTemplateType.workshop
                          ? 'Örn: Atölye Uygulaması: Oda Temizliği ve Düzeni'
                          : 'Örn: Rezervasyon Tipleri ve Özellikleri'),
                  hintStyle: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 15 : 13.5,
                    color: AppColors.textHint,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: isLargeScreen ? 14 : 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeTemplate.accentColor, width: 1.8),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen bir not başlığı girin';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            _buildSpeechDictationButton(
              targetController: _titleController,
              isLargeScreen: isLargeScreen,
              isCompact: !isLargeScreen,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContentField({
    required bool isLargeScreen,
    required NoteTemplate activeTemplate,
    required bool isWide,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Not İçeriği',
              style: GoogleFonts.inter(
                fontSize: isLargeScreen ? 15 : 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            if (_selectedTemplateType != NoteTemplateType.general)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                decoration: BoxDecoration(
                  color: activeTemplate.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  activeTemplate.title,
                  style: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 12 : 11,
                    fontWeight: FontWeight.w700,
                    color: activeTemplate.accentColor,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 7),
        // Hızlı Ekleme Çubuğu
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                'Hızlı Ekle: ',
                style: GoogleFonts.inter(
                  fontSize: isLargeScreen ? 13 : 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              _buildQuickInsertChip('• Madde', '• ', isLargeScreen: isLargeScreen),
              _buildQuickInsertChip('🦺 İSG', '🦺 İş Güvenliği: ', isLargeScreen: isLargeScreen),
              _buildQuickInsertChip('⚠️ Dikkat', '⚠️ Dikkat: ', isLargeScreen: isLargeScreen),
              _buildQuickInsertChip('💡 İpucu', '💡 İpucu: ', isLargeScreen: isLargeScreen),
              _buildQuickInsertChip('⚖️ Fark', '⚖️ Fark: ', isLargeScreen: isLargeScreen),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_selectedTemplateType == NoteTemplateType.workshop)
          _buildWorkshopFlowEditor(isWide)
        else if (_selectedTemplateType == NoteTemplateType.comparison)
          _buildComparisonFlowEditor(isWide)
        else
          Stack(
            children: [
              TextFormField(
                controller: _contentController,
                focusNode: _contentFocusNode,
                onTap: _onFieldTap,
                minLines: isLargeScreen ? 8 : 6,
                maxLines: isLargeScreen ? 11 : (isWide ? 14 : 10),
                style: GoogleFonts.inter(
                  fontSize: isLargeScreen ? 16 : 14,
                  height: 1.48,
                ),
                decoration: InputDecoration(
                  hintText: _selectedTemplateType == NoteTemplateType.comparison
                      ? 'Karşılaştırılan kavramları, farkları ve sektörel örnekleri yazın...'
                      : 'Önemli noktalar, sınavda çıkabilecek terimler veya kendi özetin...',
                  hintStyle: GoogleFonts.inter(
                    fontSize: isLargeScreen ? 14.5 : 13.5,
                    color: AppColors.textHint,
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: isLargeScreen ? 16 : 14,
                    bottom: 50,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: activeTemplate.accentColor, width: 1.8),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen not içeriğini boş bırakmayın';
                  }
                  return null;
                },
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: _buildSpeechDictationButton(
                  targetController: _contentController,
                  isLargeScreen: isLargeScreen,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildColorPicker({required bool isLargeScreen, required Color themeBorderColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Defter Kağıdı Rengi',
          style: GoogleFonts.inter(
            fontSize: isLargeScreen ? 15 : 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(NoteColors.bgColors.length, (idx) {
            final isSel = _selectedColorIndex == idx;
            final pickerColor = NoteColors.pickerColors[idx];
            final borderColor = NoteColors.borderColors[idx];
            final colorName = NoteColors.colorNames[idx];

            return InkWell(
              onTap: () => setState(() => _selectedColorIndex = idx),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: isLargeScreen ? 44 : (MediaQuery.sizeOf(context).width >= 768 ? 46 : 38),
                      height: isLargeScreen ? 44 : (MediaQuery.sizeOf(context).width >= 768 ? 46 : 38),
                      decoration: BoxDecoration(
                        color: pickerColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSel ? Colors.white : Colors.white.withValues(alpha: 0.9),
                          width: isSel ? 3.0 : 1.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: pickerColor.withValues(alpha: isSel ? 0.6 : 0.25),
                            blurRadius: isSel ? 10 : 4,
                            offset: const Offset(0, 2),
                          ),
                          if (isSel)
                            BoxShadow(
                              color: borderColor,
                              spreadRadius: 2.4,
                              blurRadius: 0,
                            ),
                        ],
                      ),
                      child: isSel
                          ? const Icon(
                              Icons.check_rounded,
                              size: 22,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      colorName,
                      style: GoogleFonts.inter(
                        fontSize: isLargeScreen ? 12.5 : (MediaQuery.sizeOf(context).width >= 768 ? 12 : 10.5),
                        fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                        color: isSel ? borderColor : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTagChips({required bool isLargeScreen, required Color themeBorderColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Çalışma Etiketi',
              style: GoogleFonts.inter(
                fontSize: isLargeScreen ? 15 : 12.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            if (_selectedTag.isNotEmpty)
              InkWell(
                onTap: () => setState(() => _selectedTag = ''),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.close_rounded, size: 14, color: Color(0xFFEF4444)),
                      const SizedBox(width: 2),
                      Text(
                        'Etiketi Kaldır',
                        style: GoogleFonts.inter(
                          fontSize: isLargeScreen ? 12.5 : 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // 0. Etiket Yok Seçeneği
            ChoiceChip(
              avatar: Icon(
                Icons.label_off_rounded,
                size: 15,
                color: _selectedTag.isEmpty ? Colors.white : const Color(0xFF64748B),
              ),
              label: const Text('Etiket Yok'),
              selected: _selectedTag.isEmpty,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedTag = '');
                }
              },
              labelStyle: GoogleFonts.inter(
                fontSize: isLargeScreen ? 14 : 12,
                fontWeight: _selectedTag.isEmpty ? FontWeight.w700 : FontWeight.w500,
                color: _selectedTag.isEmpty ? Colors.white : AppColors.textPrimary,
              ),
              selectedColor: const Color(0xFF64748B),
              backgroundColor: isLargeScreen ? Colors.white : AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: _selectedTag.isEmpty ? const Color(0xFF64748B) : AppColors.divider,
                ),
              ),
            ),
            // Diğer Etiketler
            ..._tags.map((tag) {
              final isSelected = _selectedTag == tag;
              return ChoiceChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedTag = selected ? tag : '');
                },
                labelStyle: GoogleFonts.inter(
                  fontSize: isLargeScreen ? 14 : 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                selectedColor: themeBorderColor,
                backgroundColor: isLargeScreen ? Colors.white : AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: isSelected ? themeBorderColor : AppColors.divider,
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  // ── Mobil (iOS / Android) Açılır Pencere Şeklinde Yan Yana Renk ve Etiket Seçici ──
  Widget _buildMobileColorAndTagRow(Color themeBorderColor) {
    return Row(
      children: [
        // 1. Defter Kağıdı Rengi Açılır Seçici
        Expanded(
          child: InkWell(
            onTap: () => _showColorPickerModal(themeBorderColor),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFCBD5E1)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: NoteColors.pickerColors[_selectedColorIndex],
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: NoteColors.borderColors[_selectedColorIndex],
                        width: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Kağıt Rengi',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          NoteColors.colorNames[_selectedColorIndex],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 22,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // 2. Çalışma Etiketi Açılır Seçici & Hızlı Çarpı Kaldırma Butonu
        Expanded(
          child: InkWell(
            onTap: () => _showTagPickerModal(themeBorderColor),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _selectedTag.isNotEmpty
                      ? themeBorderColor.withValues(alpha: 0.45)
                      : const Color(0xFFCBD5E1),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: _selectedTag.isNotEmpty
                          ? themeBorderColor.withValues(alpha: 0.12)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      _selectedTag.isNotEmpty ? Icons.label_rounded : Icons.label_off_rounded,
                      size: 14,
                      color: _selectedTag.isNotEmpty ? themeBorderColor : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Etiket',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          _selectedTag.isNotEmpty ? _selectedTag : 'Etiket Yok',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _selectedTag.isNotEmpty ? AppColors.textPrimary : const Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedTag.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedTag = '');
                      },
                      child: Tooltip(
                        message: 'Etiketi Kaldır',
                        child: Container(
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 13,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 22,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showColorPickerModal(Color themeBorderColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.palette_rounded, color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Defter Kağıdı Rengi',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              Text(
                'Not kartınızın görünüm ve vurgu rengini seçin',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(NoteColors.bgColors.length, (idx) {
                  final isSel = _selectedColorIndex == idx;
                  final pickerColor = NoteColors.pickerColors[idx];
                  final borderColor = NoteColors.borderColors[idx];
                  final colorName = NoteColors.colorNames[idx];

                  return InkWell(
                    onTap: () {
                      setState(() => _selectedColorIndex = idx);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: pickerColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel ? Colors.white : Colors.white.withValues(alpha: 0.9),
                                width: isSel ? 3.0 : 1.8,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: pickerColor.withValues(alpha: isSel ? 0.6 : 0.25),
                                  blurRadius: isSel ? 10 : 4,
                                  offset: const Offset(0, 2),
                                ),
                                if (isSel)
                                  BoxShadow(
                                    color: borderColor,
                                    spreadRadius: 2.4,
                                    blurRadius: 0,
                                  ),
                              ],
                            ),
                            child: isSel
                                ? const Icon(
                                    Icons.check_rounded,
                                    size: 22,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            colorName,
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                              color: isSel ? borderColor : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showTagPickerModal(Color themeBorderColor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.label_rounded, color: Color(0xFF6366F1), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Çalışma Etiketi Seçin',
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              Text(
                'Notunuzu filtrelemek ve düzenlemek için bir etiket belirleyin',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // 0. Etiket Yok Seçeneği (Açık ve Belirgin)
                  ChoiceChip(
                    avatar: Icon(
                      Icons.label_off_rounded,
                      size: 16,
                      color: _selectedTag.isEmpty ? Colors.white : const Color(0xFF64748B),
                    ),
                    label: const Text('Etiket Yok'),
                    selected: _selectedTag.isEmpty,
                    onSelected: (selected) {
                      setState(() => _selectedTag = '');
                      Navigator.pop(ctx);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: _selectedTag.isEmpty ? FontWeight.w700 : FontWeight.w500,
                      color: _selectedTag.isEmpty ? Colors.white : AppColors.textPrimary,
                    ),
                    selectedColor: const Color(0xFF64748B),
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedTag.isEmpty ? const Color(0xFF64748B) : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  // Mevcut etiketler
                  ..._tags.map((tag) {
                    final isSelected = _selectedTag == tag;
                    return ChoiceChip(
                      label: Text(tag),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedTag = selected ? tag : '');
                        Navigator.pop(ctx);
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      labelStyle: GoogleFonts.inter(
                        fontSize: 13.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      selectedColor: themeBorderColor,
                      backgroundColor: const Color(0xFFF1F5F9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? themeBorderColor : const Color(0xFFCBD5E1),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRewardInfoBanner({required bool isLargeScreen}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Row(
        children: [
          const Icon(Icons.stars_rounded, size: 20, color: Color(0xFF4F46E5)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Notunu kaydettiğinde +5 Puan ve rozet ilerlemesi kazanırsın!',
              style: GoogleFonts.inter(
                fontSize: isLargeScreen ? 13.5 : 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF3730A3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required bool isLargeScreen,
    required Color themeBorderColor,
    required bool isEditing,
  }) {
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 8,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: isLargeScreen ? 14 : 12,
            ),
          ),
          child: Text(
            'Vazgeç',
            style: GoogleFonts.inter(
              fontSize: isLargeScreen ? 15.5 : 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _onSave,
          icon: Icon(Icons.check_rounded, color: Colors.white, size: isLargeScreen ? 20 : 18),
          label: Text(
            isEditing ? 'Güncelle' : 'Notu Kaydet',
            style: GoogleFonts.inter(
              fontSize: isLargeScreen ? 16 : 14.5,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeBorderColor,
            padding: EdgeInsets.symmetric(
              horizontal: isLargeScreen ? 26 : 24,
              vertical: isLargeScreen ? 15 : 13,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 2,
          ),
        ),
      ],
    );
  }
}
