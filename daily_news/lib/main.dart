import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor:  Color(0xFFF5F5F5)
      ),
      debugShowCheckedModeBanner: false,
      home: NewIndex(),
    );
  }
}

class NewIndex extends StatefulWidget {
  const NewIndex({super.key});

  @override
  State<NewIndex> createState() => _NewIndexState();
}

class _NewIndexState extends State<NewIndex> {
  late Map resMap;
  late List resList = [];
  Future apiCall({var data = "pakistan"}) async {
    var apiKey = "0da1dae8929349919971f7dacaa51333";
    http.Response response = await http.get(
        Uri.parse("https://newsapi.org/v2/everything?q=$data&apiKey=$apiKey"));

    if (response.statusCode == 200) {
      setState(() {
        resMap = jsonDecode(response.body);
        resList = resMap["articles"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    apiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
      AppBar(
        title: Text('World News', style: TextStyle(fontWeight: FontWeight.bold,),),
        backgroundColor: Colors.blueGrey[200],
      ),

    
      body: Column(
        
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) async {
                setState(() {
                  var dataNow = value;
                  apiCall(data: dataNow);
                 });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                  hintText: 'Search for news....',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: Icon(Icons.search)),
            ),
          ),
          resList.isNotEmpty ?
          Expanded(
            child: ListView.builder(
              itemCount: resList.length,
              itemBuilder: (context, index) {
                var article = resList[index];
                return article["title"] == null ||
                        article["description"] == null ||
                        article["content"] == null ||
                        article["title"] == "[Removed]" ||
                        article["description"] == "[Removed]" ||
                        article["content"] == "[Removed]"
                    ? SizedBox.shrink()
                    : Card(
                      color: Colors.white,
                        margin: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                child: Icon(Icons.account_circle),
                              ),
                              title: Text(
                                article["author"]?.toString() ??
                                    "Unknown Author",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                  article["publishedAt"]?.toString() ?? ""),
                              trailing: Icon(Icons.more_vert),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article["title"].toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(article["description"].toString(),
                                      style: TextStyle(fontSize: 14)),
                                  SizedBox(height: 8),
                                  Text(article["content"].toString(),
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                           if (article["urlToImage"] != null &&
                          article["urlToImage"] != "")
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                            article["urlToImage"],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(); // Hide image on error
                            },
                          ),
                        ),

                            SizedBox(height: 15,),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround, // Space out icons evenly
                                children: [
                                  // Like Icon
                                  Column(
                                    children: [
                                      Icon(Icons.thumb_up, color: Colors.blue),
                                      SizedBox(
                                          height:
                                              5), // Space between icon and text
                                      Text("Like",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),

                                  // Comment Icon
                                  Column(
                                    children: [
                                      Icon(Icons.comment, color: Colors.green),
                                      SizedBox(height: 5),
                                      Text("Comment",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),

                                  // Share Icon
                                  Column(
                                    children: [
                                      Icon(Icons.share, color: Colors.purple),
                                      SizedBox(height: 5),
                                      Text("Share",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),

                                  // Additional Icon (e.g., Bookmark or More)
                                  Column(
                                    children: [
                                      Icon(Icons.bookmark, color: Colors.red),
                                      SizedBox(height: 5),
                                      Text("Save",
                                          style: TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
              },
            ),
          ):
  Center(child: CircularProgressIndicator(),)
        ],
      ),
    );
  }
}



