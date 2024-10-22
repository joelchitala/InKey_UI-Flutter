import 'dart:math';

String generateFullTimeStamp({DateTime? date}) {
  DateTime now = date ?? DateTime.now();
  return "${now.second}:${now.minute}:${now.hour}::${now.day}-${now.month}-${now.year}";
}

String generateUUID(int max) {
  return "${Random().nextInt(max)}_${generateFullTimeStamp()}";
}

(bool, List<Type>) isJsonSerializable(value) {
  List<Type> acceptableLiterals = [
    Null,
    String,
    num,
    bool,
  ];

  List<Type> acceptableTypes = [
    ...acceptableLiterals,
    List<dynamic>,
    Map<String, dynamic>
  ];

  if (value == null || value is String || value is num || value is bool) {
    return (
      true,
      acceptableTypes,
    );
  }

  if (value is List<dynamic> || value is Map<String, dynamic>) {
    List<String> types =
        generalRunTimeExtractor(value.runtimeType.toString(), false);

    var literals = acceptableLiterals.map((l) => l.toString()).toList();

    for (var type in types) {
      bool results = literals.contains(type);

      if (!results) {
        return (
          false,
          acceptableTypes,
        );
      }
    }
    return (
      true,
      acceptableTypes,
    );
  }

  return (
    false,
    acceptableTypes,
  );
}

List<String> splitIgnoringCommasInAngleBrackets(String text) {
  List<String> result = [];
  StringBuffer currentSegment = StringBuffer();
  int angleBracketDepth = 0; // Keeps track of nested angle brackets

  for (int i = 0; i < text.length; i++) {
    String char = text[i];

    if (char == '<') {
      // Entering angle brackets
      angleBracketDepth++;
      currentSegment.write(char);
    } else if (char == '>') {
      // Exiting angle brackets
      angleBracketDepth--;
      currentSegment.write(char);
    } else if (char == ',' && angleBracketDepth == 0) {
      // Only split when outside angle brackets
      result.add(currentSegment.toString().trim());
      currentSegment.clear();
    } else {
      // Normal character, just add it to the current segment
      currentSegment.write(char);
    }
  }

  // Add the final segment
  if (currentSegment.isNotEmpty) {
    result.add(currentSegment.toString().trim());
  }

  return result;
}

List<String> generalRunTimeExtractor(
    String runType, bool includeStripPartition) {
  runType = runType.trim();

  String initialExtraction = extractTypeFromString(runType);

  var split = splitIgnoringCommasInAngleBrackets(initialExtraction);

  List<String> extractedTypes = [];

  for (var i = 0; i < split.length; i++) {
    String partition = split[i].trim();

    if (partition.isEmpty) {
      continue;
    }

    if (partition.contains("<") && partition.contains(">")) {
      List<String> extracted =
          generalRunTimeExtractor(partition, includeStripPartition);
      var strippedPartition = partition.substring(0, partition.indexOf("<"));

      extractedTypes = includeStripPartition
          ? [...extractedTypes, strippedPartition, ...extracted]
          : [...extractedTypes, ...extracted];
    } else {
      extractedTypes.add(partition);
    }
  }

  return extractedTypes;
}

String extractTypeFromString(String runType) {
  runType = runType.trim();

  if (runType.isEmpty) {
    return "";
  }

  var str = runType.substring(
    runType.indexOf("<"),
    runType.length,
  );

  if (str.length < 2) {
    return "";
  }

  return str.substring(1, str.length - 1);
}

Map<String, dynamic> deepCopyMap(Map original) {
  Map<String, dynamic> newMap = {};

  original.forEach((key, value) {
    if (value is Map) {
      // Recursively deep copy nested maps
      newMap[key] = deepCopyMap(value);
    } else if (value is List) {
      // Deep copy lists
      newMap[key] = List.from(value);
    } else {
      // Primitive types can be directly assigned
      newMap[key] = value;
    }
  });

  return newMap;
}

G? toEnumType<G>(List<G> enumObj, String value) {
  for (var enumVal in enumObj) {
    if (value == enumVal.toString()) {
      return enumVal;
    }
  }

  return null;
}
