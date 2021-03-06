package thx.tpl;

class TString {
  public var s : String;
  public function new(str)
    this.s = str;
  @:keep
  public function toString()
    return s;
}

typedef SafeString = TString;

class UnsafeString extends TString {
  public dynamic function escape(str)
    return StringTools.htmlEscape(str, true);

  public override function new(s , escapeMethod = null) {
    super(s);
    if(escapeMethod != null)
      escape = escapeMethod;
  }

  @:keep
  public override function toString()
    return escape(s);
}

@:keep
class Output {
  var buf: StringBuf;
  public function new(escapeMethod = null) {
    if(escapeMethod != null) escape = escapeMethod;
    buf = new StringBuf();
  }

  public dynamic function escape(str)
    return str;

  public inline function unsafeAdd(str : Dynamic)
    if(Std.is(str, TString))
      add(str.toString());
    else
      add(escape(Std.string(str)));

  public inline function add(str: String)
    buf.add(str);

  public inline function toString()
    return buf.toString();

  public static function safe(str : String)
    return new SafeString(str);

  public static function unsafe(str : String)
    return new UnsafeString(str);
}
