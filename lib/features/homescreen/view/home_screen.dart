import '/core/api/dio_helper.dart';
import '/features/homescreen/data/coffee_service.dart';
import '/features/homescreen/data/post_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> postList = [];
  List<dynamic> coffeeList = [];

  bool isLoading = true;

  Future<void> getPost() async {
    try {
      final response = await PostService.getPost();
      setState(() {
        postList = response;
        isLoading = false;
      });
    } catch (e) {
      throw DioHelper().handleError(e);
      // throw Exception(e);
    }
  }

  Future<void> getCoffee() async {
    try {
      final response = await CoffeeService.getCofee();
      setState(() {
        coffeeList = response;
        isLoading = false;
      });
    } catch (e) {
      throw DioHelper().handleError(e);
    }
  }

  @override
  void initState() {
    getPost();
    getCoffee(); // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Api'),
          centerTitle: true,
          bottom: TabBar(tabs: [Text('POST'), Text('COFFEE')]),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  ListView.separated(
                    itemBuilder: (context, index) {
                      final post = postList[index];
                      return ListTile(
                        title: Text(post['title']),
                        subtitle: Text(post['body']),
                      );
                    },
                    itemCount: postList.length,
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                  ListView.separated(
                    itemBuilder: (context, index) {
                      final coffee = coffeeList[index];
                      return ListTile(
                        title: Text(coffee['title']),
                        subtitle: Text(coffee['description']),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                    itemCount: coffeeList.length,
                  ),
                ],
              ),
      ),
    );
  }
}
