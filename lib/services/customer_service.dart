import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_admin_1/models/customer_model.dart';

class CustomerService {
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  Future<CustomerModel> getCustomerDetails(String kodeCust) async {
    var url = Uri.parse('$baseUrl/customer/alamat/$kodeCust');
    var response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['data'];
      print('data customer: $data');
      return CustomerModel.fromJson(data);
    } else {
      throw Exception('Error in getCustomerDetails');
    }
  }
}
