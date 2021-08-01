import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/bloc/get_sources_bloc.dart';
import 'package:news/elements/error_element.dart';
import 'package:news/elements/loader_element.dart';
import 'package:news/model/source.dart';
import 'package:news/model/source_response.dart';
import 'package:news/screens/tabs/source_detail.dart';

class SourcesScreen extends StatefulWidget {
  const SourcesScreen({Key key}) : super(key: key);

  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  @override
  void initState() {
    super.initState();
    getSourcesBloc.getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.error != null && snapshot.data.error.isNotEmpty) {
            return buildErrorWidget(snapshot.data.error);
          }
          return _buildSourceScreen(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data.error);
        } else {
          return buildLoaderWidget();
        }
      },
    );
  }

  Widget _buildSourceScreen(SourceResponse data) {
    List<SourceModel> sources = data.sources;
    return GridView.builder(
      itemCount: sources.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(
            left: 5,
            right: 5,
            top: 10,
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SourceDetail(
                    sourceModel: sources[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: sources[index].id,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/logos/${sources[index].id}.png'),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    child: Text(
                      sources[index].name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
