import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:offers/src/app/const.dart';
import 'package:offers/src/bloc/bloc.dart';
import 'package:offers/src/data/offer.dart';
import 'package:offers/src/ui/app_bar.dart';
import 'package:offers/src/ui/city.dart';
import 'package:offers/src/ui/loader.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

class Main extends StatelessWidget {
  final RefreshController _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    Bloc bloc = BlocProvider.of<Bloc>(context);
    bloc.loadOffers();
    return Scaffold(
      appBar: OffersAppBar(
        navigationItem: InkWell(
          child: Icon(Icons.location_city),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return City();
                },
              ),
            );
          },
        ),
        title: Text(
          appName,
          style: TextStyle(
            color: Colors.white,
            fontFamily: appNameFont,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SmartRefresher(
        child: ListView(
          children: <Widget>[
            OfflineBuilder(
              child: Text(
                "OfflineBuilder child",
              ),
              connectivityBuilder: (BuildContext context,
                  ConnectivityResult connectivity, Widget child) {
                debugPrint("main connectivity: $connectivity");
                final bool connected = connectivity != ConnectivityResult.none;
                debugPrint("main connected: $connected");
                return connected
                    ? StreamBuilder(
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Offer>> snapshot) {
                          Widget widget;
                          debugPrint(
                              "main snapshot.connectionState: ${snapshot.connectionState}");
                          switch (snapshot.connectionState) {
                            case ConnectionState.active:
                              debugPrint(
                                  "main snapshot.hasError: ${snapshot.hasError}");
                              debugPrint(
                                  "main snapshot.hasData: ${snapshot.hasData}");
                              if (snapshot.hasError) {
                                widget = Center(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        "$errorText: ${snapshot.error}",
                                      ),
                                    ],
                                  ),
                                );
                              } else if ((!snapshot.hasData) ||
                                  (snapshot.data.length == 0)) {
                                widget = Center(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.0,
                                      ),
                                      Text(
                                        noOffersText,
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                widget = ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(
                                        snapshot.data[index].title,
                                      ),
                                      subtitle: Text(
                                        snapshot.data[index].description,
                                      ),
                                      trailing: Text(
                                        "R\$ ${snapshot.data[index].price}",
                                      ),
                                    );
                                  },
                                  itemCount: snapshot.data.length,
                                );
                              }
                              widget = Center(
                                child: widget,
                              );
                              break;
                            default:
                              widget = Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Loader(),
                                  ],
                                ),
                              );
                              break;
                          }
                          return widget;
                        },
                        stream: bloc.offersStream,
                      )
                    : Text(
                        youAreNotConnectedText,
                      );
              },
            ),
          ],
        ),
        controller: _refreshController,
        onRefresh: (bool up) async {
          await bloc.loadOffers();
          _refreshController.sendBack(up, RefreshStatus.completed);
        },
      ),
    );
  }
}
