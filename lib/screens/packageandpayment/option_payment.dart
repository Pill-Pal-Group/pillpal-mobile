import 'package:flutter/material.dart';
import 'package:pillpalmobile/screens/packageandpayment/method_payment.dart';


class OptionPaymentScreen extends StatefulWidget {
  @override
  _OptionPaymentScreenState createState() => _OptionPaymentScreenState();
}

class _OptionPaymentScreenState extends State<OptionPaymentScreen> {
  final List<Map<String, dynamic>> packages = [
    {
      "title": "3 Tháng",
      "price": "\$29.99",
      "details": "Ideal for short-term plans."
    },
    {
      "title": "6 Tháng",
      "price": "\$54.99",
      "details": "The most popular choice."
    },
    {
      "title": "12 Tháng",
      "price": "\$99.99",
      "details": "Best value for long-term use."
    },
  ];

  int? selectedPackageIndex;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.blueAccent,
          elevation: 5,
          shape: RoundedRectangleBorder(
            // Add border radius to all Cards globally
            borderRadius:
                BorderRadius.circular(10), // Adjust radius to your preference
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Đăng ký gói'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF85FFBD), // Start color
                Color(0xFFFFFB7D) // End color
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 16),
              Image.asset('assets/images/logo.jpg', width: 100, height: 100),
              SizedBox(height: 16),
              Text('Mở khóa tất cả các tính năng của ứng dụng',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),

              SizedBox(height: 16), // Space between image and texts
              const Row(
                crossAxisAlignment: CrossAxisAlignment
                    .start, // Aligns the icon with the first line of text
                children: [
                  SizedBox(width: 8), // Space between icon and texts
                  Expanded(
                    // Use Expanded to prevent overflow
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align texts to the start
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Quét Đơn thuốc nhanh chóng',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Lên lịch nhắc nhở uống thuốc',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons
                                  .check_circle, // Example icon for the first item
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text('Tra cứu thông tin thuốc nhanh chóng',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                        // Repeat for each text item, changing the icon as needed
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16), // Space between texts and ListView
              Expanded(
                child: ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedPackageIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPackageIndex = index;
                        });
                      },
                      child: Card(
                        color: isSelected ? Colors.blue : Colors.white,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            packages[index]["title"],
                            style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${packages[index]["details"]} - ${packages[index]["price"]}",
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white70 : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MethodPaymentScreen()),
                    );
                  },
                  child: Text('Đăng ký'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
