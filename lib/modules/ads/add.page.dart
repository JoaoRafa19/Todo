import 'dart:io' show Platform;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  __AddPage createState() => __AddPage();
}

class __AddPage extends State<AddPage> {
  static const AdRequest request = AdRequest(
    keywords: <String>['imóvel', 'apartamento', 'carro'],
    nonPersonalizedAds: true,
  );

  bool showingAdd = false;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  RewardedAd? _rewardedAd;

  RewardedInterstitialAd? _rewardedInterstitialAd;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();
  }

  Future _createInterstitialAd() async {
    await InterstitialAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-4292490624006412/8815368830'
            : 'ca-app-pub-4292490624006412/8815368830',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) async {
            Get.log('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            await _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) async {
            Get.log('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              await _createInterstitialAd();
            }
          },
        ));
  }

  Future _showInterstitialAd() async {
    if (_interstitialAd == null) {
      Get.log('Warning: attempt to show interstitial before loaded.');
      _createInterstitialAd();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          Get.log('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) async {
        Get.log('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        await _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (InterstitialAd ad, AdError error) async {
        ad.dispose();
        await _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(builder: (BuildContext context) {
        return Scaffold(
            body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                height: 50,
                color: Colors.blue,
                child: Center(
                  child: showingAdd
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Show Ad',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
              onTap: () async {
                setState(() {
                  showingAdd = true;
                });
                await _showInterstitialAd();
                await FirebaseAnalytics.instance
                    .logEvent(name: 'show_add', parameters: <String, dynamic>{
                  'content_type': 'interstitial',
                });
                setState(() {
                  showingAdd = false;
                });
              },
            ),
            BackButton(
              color: Colors.blue,
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ));
      }),
    );
  }
}
