import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app_lutter/data/models/TopHeadLines.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/link.dart';
import 'package:new_app_lutter/data/linkdata.dart';


class HomaPage extends StatefulWidget {
  const HomaPage({super.key});

  @override
  State<HomaPage> createState() => _HomaPageState();
}

class _HomaPageState extends State<HomaPage> {
  Future<HeadLines>? postsFuture;
  List<String> categories= ['business','entertainment','general','health','science','sports','technology'];

  static String category = 'general';
  final controller = TextEditingController();

 static String endpoint = LinkData.endpoints1;
 static String country = LinkData.country;
 static String query= '';

 // static String endpoint = LinkData.endpoints;




  static Future<HeadLines> fetchNews() async {
    final response = await http.get(Uri.parse(LinkData.url+endpoint+'?q='+query+'&country='+country+'&category='+category+'&apiKey='+LinkData.API_KEY));
    print(LinkData.url+endpoint+'?country='+LinkData.country+'&category='+category+'&apiKey='+LinkData.API_KEY);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return HeadLines.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }





  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   postsFuture = fetchNews();
  // }

  @override
  Widget build(BuildContext context) {


    Size size = MediaQuery.of(context).size!;
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(

        // FutureBuilder
        child: SingleChildScrollView(
          child: Column(


            children: [
              SizedBox(height: 20,),
             Container(
               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
               child: TextField(
                 controller: controller,
                 decoration: InputDecoration(

                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  suffixIcon : GestureDetector(
                    onTap: (){
                      setState(() {
                        country='';
                        category='';
                        endpoint=LinkData.endpoints2;
                        query=controller.text.toString();
                      });
                    },
                      child: Icon(Icons.search)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  )
                 ),

               ),
             ),
             SizedBox(

               height: size.height*0.08,
               child: ListView.builder(
                 scrollDirection: Axis.horizontal,
                   itemCount: categories.length,
                   itemBuilder: (ctx,index){
                 return Padding(
                   padding: const EdgeInsets.all(5.0),
                   child: ElevatedButton(onPressed: (){
                     setState(() {
                       endpoint = LinkData.endpoints1;
                       country = LinkData.country;
                       query= '';
                       category = categories[index];
                     });
                     print(LinkData.url+endpoint+'?country='+LinkData.country+'&category='+category+'&apiKey='+LinkData.API_KEY);

                     fetchNews();

                   }, child: Text(categories[index],style: TextStyle(color: Colors.black)),),
                 );
               }),
             ),

              FutureBuilder<HeadLines>(
                future: fetchNews(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // until data is fetched, show loader
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData) {
                    // once data is fetched, display it on screen (call buildPosts())
                    final posts = snapshot.data!;
                    return SizedBox(
                      height: size.height*0.8,
                      child: ListView.builder(

                        itemCount: posts.articles!.length,
                        itemBuilder: (context, index) {
                          final post = posts.articles![index];



                          return Column(

                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.white,
                                  ),


                                  height: 400,
                                  width: double.maxFinite,
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            topLeft: Radius.circular(20),
                                        ),
                                        child: Image.network(post.urlToImage.toString()),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(post.title.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                                          child: Text(post.content.toString(),style: TextStyle(),),
                                        ),
                                      ),


                                    ],
                                  ),

                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  } else {
                    // if no data, show simple Text
                    return const Text("No data available");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
