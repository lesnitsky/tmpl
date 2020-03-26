import 'package:intl/intl.dart';

import 'extensions/map.dart';

final _slotsRegexp = RegExp(
  r'\$\{(?<name>[A-Za-z0-9_\.]+)\}' +
      r'(\|(?<format>[a-z]+)(\((?<formatValue>.*)\))?)?',
);

class Template {
  String _source;

  Template(String source) : _source = source;

  String _format(v, String format, String formatValue) {
    switch (format) {
      case 'string':
        return v.toString();
      case 'date':
        return DateFormat(formatValue ?? 'yyyy-MM-dd hh:mm a')
            .format(v is DateTime ? v : DateTime.parse(v));
    }

    return v.toString();
  }

  String compile(Map<String, dynamic> data) {
    String compiled = _source;

    while (true) {
      final match = _slotsRegexp.firstMatch(compiled);

      if (match == null) break;

      final key = match.namedGroup('name');
      final format = match.namedGroup('format') ?? 'string';
      final formatValue = match.namedGroup('formatValue');

      final value = _format(data.nested(key), format, formatValue);

      if (value == null) {
        throw new Exception("Can't find value of $key");
      }

      compiled = compiled.replaceRange(
        match.start,
        match.end,
        _format(data.nested(key), format, formatValue),
      );
    }

    return compiled;
  }
}
