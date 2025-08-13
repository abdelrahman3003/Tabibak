class Validation {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "البريد الإلكتروني مطلوب";
    }
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value.trim())) {
      return "البريد الإلكتروني غير صالح";
    }
    return null;
  }

  static String? validatePassord(String? value) {
    if (value == null || value.isEmpty) {
      return "كلمة المرور مطلوبة";
    }
    if (value.length < 6) {
      return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "الاسم مطلوب";
    }
    if (value.trim().length < 3) {
      return "الاسم يجب أن يكون 3 أحرف على الأقل";
    }
    return null;
  }

  static String? validateRequired(String? value,
      {String fieldName = "هذا الحقل"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName مطلوب";
    }
    return null;
  }
}
