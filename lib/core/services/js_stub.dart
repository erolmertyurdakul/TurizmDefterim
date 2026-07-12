// Web dışı platformlarda dart:js kütüphanesinin derleme hatası vermesini önlemek için kullanılan stub.
class JsContext {
  const JsContext();
  void callMethod(String name, [List? args]) {}
}

const context = JsContext();
