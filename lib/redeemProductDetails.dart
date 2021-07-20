import 'package:eshop/Model/Section_Model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'Add_Address.dart';
import 'Cart.dart';
import 'Helper/Session.dart';
import 'Helper/Color.dart';
import 'Manage_Address.dart';
import 'Product_Preview.dart';

class RedeemProductDetails extends StatefulWidget {
  final Product model;
  final Map<dynamic, dynamic> m;
  const RedeemProductDetails({Key key, this.model, this.m}) : super(key: key);

  @override
  _RedeemProductDetailsState createState() => _RedeemProductDetailsState();
}

class _RedeemProductDetailsState extends State<RedeemProductDetails> {
  @override
  void initState() {
    super.initState();
    sliderList.clear();

    sliderList.add(widget.model.image);
    if (widget.model.videType != null &&
        widget.model.video != null &&
        widget.model.video.isNotEmpty &&
        widget.model.video != "") {
      sliderList.add(widget.model.image);
    }
    if (widget.model.otherImage != null && widget.model.otherImage.length > 0)
      sliderList.addAll(widget.model.otherImage);

    for (int i = 0; i < widget.model.prVarientList.length; i++) {
      for (int j = 0; j < widget.model.prVarientList[i].images.length; j++) {
        sliderList.add(widget.model.prVarientList[i].images[j]);
      }
    }
  }

  StateSetter checkoutState;

  int _curSlider = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              decoration: shadow(),
              width: 100,
              child: Card(
                elevation: 0,
                child: InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () => Navigator.of(context).pop(),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
            ),
            _slider(),
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10),
                    child: Text(
                      widget.model.name,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: colors.lightBlack),
                    ),
                  ),
                  _rate(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Points: " + widget.m["redeem_points"].toString(),
                      style: TextStyle(
                          color: colors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _shortDesc(),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  address(),
                ],
              ),
            ),
            Spacer(),
            InkWell(
              child: Container(
                  alignment: Alignment.center,
                  height: 55,
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors.grad1Color, colors.grad2Color],
                        stops: [0, 1]),
                  ),
                  child: Text("Place Order",
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: colors.white,
                          ))),
              onTap: () {
                if (selAddress == null || selAddress.isEmpty) {
                  msg = getTranslated(context, 'addressWarning');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ManageAddress(
                          home: false,
                        ),
                      ));
                }
              },
            )
          ],
        ),
      ),
    );
  }

  String msg;

  address() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.location_on),
            addressList.length > 0
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 5.0),
                            child: Text(addressList[selectedAddress].name),
                          ),
                          Text(
                            addressList[selectedAddress].address +
                                ", " +
                                addressList[selectedAddress].area +
                                ", " +
                                addressList[selectedAddress].city +
                                ", " +
                                addressList[selectedAddress].state +
                                ", " +
                                addressList[selectedAddress].country +
                                ", " +
                                addressList[selectedAddress].pincode,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(color: colors.lightBlack),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Text(
                                  addressList[selectedAddress].mobile,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(color: colors.lightBlack),
                                ),
                                Spacer(),
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: colors.lightWhite,
                                        borderRadius: new BorderRadius.all(
                                            const Radius.circular(4.0))),
                                    child: Text(
                                      getTranslated(context, 'CHANGE'),
                                      style: TextStyle(
                                          color: colors.fontColor,
                                          fontSize: 10),
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ManageAddress(
                                                  home: false,
                                                )));

                                    checkoutState(() {});
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 8.0),
                      child: GestureDetector(
                        child: Text(
                          getTranslated(context, 'ADDADDRESS'),
                          style: TextStyle(
                              color: colors.fontColor,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () async {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddAddress(
                                      update: false,
                                      index: addressList.length,
                                    )),
                          );
                          if (mounted) setState(() {});
                        },
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  _shortDesc() {
    return widget.model.shortDescription != null &&
            widget.model.shortDescription.isNotEmpty
        ? Padding(
            padding: const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8),
            child: Text(
              widget.model.shortDescription,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          )
        : Container();
  }

  _rate() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RatingBarIndicator(
            rating: double.parse(widget.model.rating),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: colors.primary,
            ),
            itemCount: 5,
            itemSize: 12.0,
            direction: Axis.horizontal,
          ),
          Text(
            " " + widget.model.rating,
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: colors.lightBlack),
          ),
          Text(
            " | " + widget.model.noOfRating + " Ratings",
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: colors.lightBlack),
          )
        ],
      ),
    );
  }

  Widget _slider() {
    double height = MediaQuery.of(context).size.height * .38;

    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            PageRouteBuilder(
              // transitionDuration: Duration(seconds: 1),
              pageBuilder: (_, __, ___) => ProductPreview(
                id: widget.model.id,
                imgList: sliderList,
                video: widget.model.video,
                videoType: widget.model.videType,
                list: true,
                from: true,
                pos: 0,
                secPos: 0,
                index: 0,
              ),
            ));
      },
      child: Stack(
        children: <Widget>[
          Container(
              height: height,
              width: double.infinity,
              child: PageView.builder(
                itemCount: sliderList.length,
                scrollDirection: Axis.horizontal,
                // controller: _pageController,
                reverse: false,
                onPageChanged: (index) {
                  if (mounted)
                    setState(() {
                      _curSlider = index;
                    });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Stack(
                    children: [
                      FadeInImage(
                        image: NetworkImage(sliderList[index]),
                        placeholder: AssetImage(
                          "assets/images/sliderph.png",
                        ),
                        height: height,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            erroWidget(height),

                        //  fit: extendImg ? BoxFit.fill : BoxFit.contain,
                      ),
                      index == 1 ? playIcon() : Container()
                    ],
                  );
                },
              )),
          Positioned.fill(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsetsDirectional.only(bottom: 5),
                  child: Text(
                    "${_curSlider + 1}/${sliderList.length}",
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(color: colors.primary),
                  ),
                  decoration: BoxDecoration(
                      color: colors.lightWhite,
                      borderRadius: BorderRadius.circular(5)),
                  padding: EdgeInsets.symmetric(horizontal: 5),
                )),
          ),
          indicatorImage(),
        ],
      ),
    );
  }

  indicatorImage() {
    String indicator = widget.model.indicator;
    return Positioned.fill(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
          alignment: Alignment.bottomRight,
          child: indicator == "1"
              ? SvgPicture.asset("assets/images/vag.svg")
              : indicator == "2"
                  ? SvgPicture.asset("assets/images/nonvag.svg")
                  : Container()),
    ));
  }

  playIcon() {
    return Align(
        alignment: Alignment.center,
        child: (widget.model.videType != null &&
                widget.model.video != null &&
                widget.model.video.isNotEmpty &&
                widget.model.video != "")
            ? Icon(
                Icons.play_circle_fill_outlined,
                color: colors.primary,
                size: 35,
              )
            : Container());
  }

  List<String> sliderList = [];
}
