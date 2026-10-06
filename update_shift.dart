import 'dart:io';

void main() {
  var file = File('lib/features/doctor/presentation/views/widget/shift_schedule_item.dart');
  var content = file.readAsStringSync();
  content = content.replaceAll(
    'Theme.of(context).textTheme.titleMedium?.copyWith(',
    'Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, '
  );
  file.writeAsStringSync(content);
}
