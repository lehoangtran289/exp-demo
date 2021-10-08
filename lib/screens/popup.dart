import 'package:exp_demo/common/utils.dart';
import 'package:flutter/material.dart';

class DiscountInfo extends StatelessWidget {
  final String msisdn;

  DiscountInfo(this.msisdn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
          child: RichText(
            text: const TextSpan(
              style: TextStyle(color: Colors.black, height: 1.5, fontSize: 16),
              children: <TextSpan>[
                TextSpan(
                    text: 'Khuyến mãi tít mù - Lướt mạng vù vù chỉ với 1.000đ',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                TextSpan(
                    text: '\nSiêu ưu đãi đã đổ bộ ViettelPay',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                TextSpan(text: ' \n'),
                TextSpan(
                    text: '\n- Dành tặng khách hàng thực hiện '
                        'giao dịch thanh toán trên ViettelPay (thuộc '
                        'tập khách hàng được Viettel gửi thông báo tham gia chương trình khuyến mãi) \n'
                        '- Nhận ngay gói voucher mua data trên '
                        'ViettelPay #Giá_1000đ dành cho gói ST5K & '
                        'ST15K\n'),
                TextSpan(
                    text: '- Thời gian chương trình:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: ' tới 10/02/2022'),
                TextSpan(
                    text:
                        '\n\nChi tiết vui lòng xem tại: https://1.viettelpay.vn/g1k'),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.0)),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Trải nghiệm ngay',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    // trackpoint
                    trackEvent('exp_experience', 'BUTTON', 'USER', 'CLICK',
                        args: {'identity': msisdn});
                    Navigator.pop(context);
                    showDialog<String>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) => const AlertDialog(
                        content: Text('Trải nghiệm thành công :D'),
                      ),
                    );
                  },
                ),
              ),
            ]),
      ),
    );
  }
}
