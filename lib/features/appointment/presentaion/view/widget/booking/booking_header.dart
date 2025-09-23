import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageCircle(
            urlImage:
                "https://www.bing.com/th/id/OIP.l96BdnBni68Vv9r_AgP7UgHaHa?w=224&h=211&c=8&rs=1&qlt=90&o=6&cb=thwsc4&pid=3.1&rm=2"),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("د. أحمد محمد",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("استشاري جراحة العظام",
                style: TextStyle(color: Colors.grey[700])),
            Text("سعر الكشف: 300 جنيه", style: TextStyle(color: Colors.blue)),
          ],
        )
      ],
    );
  }
}
