import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:intl/intl.dart';
import 'package:offers/src/app/const.dart';
import 'package:offers/src/bloc/bloc.dart';
import 'package:offers/src/data/offer.dart';
import 'package:offers/src/ui/app_bar.dart';
import 'package:offers/src/ui/city.dart';
import 'package:offers/src/ui/loader.dart';
import "package:pull_to_refresh/pull_to_refresh.dart";

final currencyNumberFormat = NumberFormat("#,##0.00", "pt_BR");

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
      body: Container(
        child: SmartRefresher(
          child: ListView(
            children: <Widget>[
              OfflineBuilder(
                child: Text(
                  "OfflineBuilder child",
                ),
                connectivityBuilder: (BuildContext context,
                    ConnectivityResult connectivity, Widget child) {
                  debugPrint("main connectivity: $connectivity");
                  final bool connected =
                      connectivity != ConnectivityResult.none;
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
                                  snapshot.data.sort((offer1, offer2) =>
                                      offer1.title.compareTo(offer2.title));
                                  widget = ListView.builder(
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        child: ListTile(
                                          title: Text(
                                            snapshot.data[index].title,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            snapshot.data[index].description,
                                          ),
                                          trailing: Text(
                                            "R\$ ${currencyNumberFormat.format(snapshot.data[index].price)}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              5.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: snapshot.data.length,
                                    shrinkWrap: true,
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
        padding: const EdgeInsets.all(
          10.0,
        ),
      ),
    );
  }
}
