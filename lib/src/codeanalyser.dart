library lib_hdl.code_analyser;

import "dart:collection";
import "Syntax.dart" as syntax;
class CodeAnalysisError
{
  final int errorID;
  final List info;
  CodeAnalysisError(this.errorID, this.info);
}
class CodeAnalyser {
  final syntax.Chip root;
  Map<String, int> inPinMap;
  Map<String, int> outPinMap;
  List<CodeAnalysisError> errors = [];
  CodeAnalyser(syntax.SyntaxTree syntaxTree)
    : root = syntaxTree.root
  {
    analysizeInterface();
  }
  void analysizeInterface() {
    inPinMap = new HashMap();
    final inPins = root.inPins;
    for (int i=0; i<inPins.length; i++)
    {
      final pindef = inPins[i];
      if (inPinMap.containsKey(pindef.name))
    }
  }
}
