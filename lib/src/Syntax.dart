library lib_hdl.syntax;

class SyntaxTree {
  Chip root;
  SyntaxTree(this.root);
}

class SyntaxNodeInfo {
  final int position;
  final int width;
  SyntaxNodeInfo(this.position, this.width);
}

class Chip {
  final SyntaxNodeInfo info;
  final PinList inPins;
  final PinList outPins;
  final Parts parts;
  Chip(this.inPins, this.outPins, this.parts, {this.info});
}

class PinList {
  final SyntaxNodeInfo info;
  final List<PinDef> defs;
  PinList(this.defs, {this.info});

  int get length => defs.length;
  PinDef operator[](int index) => defs[index];
}

class PinDef
{
  final SyntaxNodeInfo info;
  final int type;
  final Identifier nameToken;
  final int width;
  PinDef.single(this.nameToken, {this.info})
      : type = 1,
        width = 1;

  PinDef.bus(this.nameToken, this.width, {this.info})
      : type = 2;

  String get name => nameToken.value;
  String get debugString => "";
}

class Parts {
  final SyntaxNodeInfo info;
  final List<Part> parts;
  Parts(this.parts, {this.info});

  String get debugString => "";
}

class Part {
  final SyntaxNodeInfo info;
  final Identifier partName;
  final List<Connection> conns;
  Part(this.partName, this.conns, {this.info});

  String get debugString =>
      "${partName.debugString}(${conns.map((i) => i.debugString).join(', ')});\n";
}

class Connection {
  final SyntaxNodeInfo info;
  final PinRef part;
  final PinRef chip;
  Connection(this.part, this.chip, {this.info});

  String get debugString => "${part.debugString}=${chip.debugString}";
}

class PinRef {
  final SyntaxNodeInfo info;
  final int type;
  final Identifier name;
  final int index1;
  final int index2;
  PinRef.single(this.name, {this.info})
      : type = 1,
        index1 = -1,
        index2 = -1;

  PinRef.indexed(this.name, this.index1, {this.info})
      : type = 2,
        index2 = -1;
  PinRef.subarray(this.name, this.index1, this.index2, {this.info})
      : type = 3;

  String get debugString => "";
}

class Identifier {
  final SyntaxNodeInfo info;
  final String value;
  Identifier(this.value, {this.info});

  String get debugString => value;
}

class Number {
  final SyntaxNodeInfo info;
  final int value;
  Number(this.value, {this.info});

  String get debugString => value.toString();
}
