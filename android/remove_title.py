import os

filepath = "/Users/hello/development/Projects/Tabibak/lib/features/doctor/presentation/views/widget/doctor_details_body.dart"

with open(filepath, 'r') as f:
    content = f.read()

old_block = """    if (clinics.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: AppStrings.clinicDetails),
          10.hBox,
          Container(
            padding: const EdgeInsets.all(20),"""

new_block = """    if (clinics.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),"""

content = content.replace(old_block, new_block)

with open(filepath, 'w') as f:
    f.write(content)

print("Title removed.")
