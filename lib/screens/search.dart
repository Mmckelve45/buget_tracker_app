

//  //https://discountapi.com/apidocs

//   Future<String> getData() async {
//     http.Response response = await http
//         .get(Uri.parse('https://jsonplaceholder.typicode.com/posts'), headers: {
//       // "key" : "somerandomkey",
//       "Accept": "application/json"
//     });
//     print(response.body);
//     List data = jsonDecode(response.body);
//     print(data[0]["title"]);
//     return response.body;
//   }