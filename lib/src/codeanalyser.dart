library lib_hdl.code_analyser;

import "dart:collection";
import "Syntax.dart" as syntax;

class CodeAnalysisError {
  final int errorID;
  final List info;
  CodeAnalysisError(this.errorID, this.info);
  CodeAnalysisError.duplicatePinDefinition(int pin1, int pin2)
      : errorID = 1,
        info = [pin1, pin2];
}

//Internal class used in CodeAnalyser
class _InternalPinDef {
  final String name;
  final int width;
  final int partIndex;
  final int connIndex;
  _InternalPinDef(this.name, this.width, this.partIndex, this.connIndex);
}

class CodeAnalyser {
  final syntax.Chip root;
  int _inPinCount;
  int _outPinCount;
  int _totalCount;

  bool _hasInternalPinDef;
  bool _isBuiltin;
  List<_InternalPinDef> internalPins;

  Map<String, int> pinMap = new HashMap();

  List<int> pinType;
  List<CodeAnalysisError> errors = [];
  CodeAnalyser(syntax.SyntaxTree syntaxTree) : root = syntaxTree.root {
    _hasInternalPinDef = root.internalPins != null;
    analysizeInterface();
    if (!_isBuiltin) {
      if (!_hasInternalPinDef) _collectInternalPinDef();
    }
  }

  int getPinTypeFromIndex(int index) =>
      index < _inPinCount ? 1 : (index < _inPinCount + _outPinCount ? 2 : 3);

  void _addError(CodeAnalysisError error) {
    errors.add(error);
  }

  void analysizeInterface() {
    _inPinCount = root.inPins.length;
    _outPinCount = root.outPins.length;
    final inPins = root.inPins;
    final outPins = root.outPins;
    for (int i = 0; i < _inPinCount + _outPinCount; i++) {
      final pindef = (i < _inPinCount ? inPins[i] : outPins[i - _inPinCount]);
      if (pinMap.containsKey(pindef.name)) {
        _addError(new CodeAnalysisError.duplicatePinDefinition(
            pinMap[pindef.name], i));
      }
    }
  }

  void _collectInternalPinDef() {
    int internalPinCount = 0;
    final parts = root.parts;
    for (int i = 0; i < parts.length; ++i) {
      final part = parts[i];
      final conns = part.conns;
      for (int j = 0; j < conns.length; ++j) {
        final connChip = conns[j].chip;
        if (!pinMap.containsKey(connChip.name)) {
          internalPins
              .add(new _InternalPinDef(connChip.name, connChip.width, i, j));
          pinMap.putIfAbsent(connChip.name,
              () => internalPinCount + _inPinCount + _outPinCount);
          ++internalPinCount;
        }
      }
    }

    assert(internalPinCount == internalPins.length);
  }
}
