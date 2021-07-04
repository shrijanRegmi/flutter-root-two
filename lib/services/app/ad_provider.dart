import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdProvider extends ChangeNotifier {
  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;
  BannerAd _bannerAd;
  bool _isBannerLoaded = false;
  bool _isRewardedLoaded = false;
  int _bannerTries = 5;

  InterstitialAd get interstitialAd => _interstitialAd;
  RewardedAd get rewardedAd => _rewardedAd;
  BannerAd get bannerAd => _bannerAd;
  bool get isBannerLoaded => _isBannerLoaded;
  bool get isRewardedLoaded => _isRewardedLoaded;
  int get bannerTries => _bannerTries;

  // String get bannerId => 'ca-app-pub-3940256099942544/6300978111'; // test ad
  String get bannerId => 'ca-app-pub-1736091010557588/7791611250';
  // String get interstitialId => 'ca-app-pub-3940256099942544/1033173712'; // test ad
  String get interstitialId => 'ca-app-pub-1736091010557588/6286957898';
  // String get rewardedId => 'ca-app-pub-3940256099942544/5224354917'; // test ad
  String get rewardedId => 'ca-app-pub-1736091010557588/8763279120';

  // on dispose
  void onDispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
  }

  // get banner ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: '$bannerId',
      size: AdSize.fullBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          updateIsBannerLoaded(true);
        },
        onAdFailedToLoad: (ad, error) {
          print('FAILED TO LOAD BANNER: ${error.code} ${error.message}');
          updateIsBannerLoaded(false);
          if (_bannerTries >= 0) {
            updateBannerTries(_bannerTries - 1);
            loadBannerAd();
          }
        },
      ),
    );
    notifyListeners();

    _bannerAd.load();
  }

  // load interstitial ad
  Future<void> loadInterstitialAd() async {
    return await InterstitialAd.load(
      adUnitId: '$interstitialId',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          _interstitialAd = ad;
          notifyListeners();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  // show interstitial ad
  Future<void> showInterstitialAd({
    final bool forced = false,
    final int chance = 30,
  }) async {
    bool _show = forced;

    if (!forced) {
      final _rand = Random();
      final _randNum = _rand.nextInt(100);
      _show = _randNum >= (100 - chance);
    }

    if (_show) await _interstitialAd?.show();

    loadInterstitialAd();
  }

  // load rewarded ad
  Future<void> loadRewardedAd() async {
    return await RewardedAd.load(
      adUnitId: '$rewardedId',
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('$ad loaded.');
          _rewardedAd = ad;
          notifyListeners();
          updateIsRewardedLoaded(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  // show rewarded ad
  Future<void> showRewardedAd({@required final Function onRewarded}) async {
    return await _rewardedAd?.show(
      onUserEarnedReward: (RewardedAd ad, RewardItem item) {
        onRewarded();
      },
    );
  }

  // update value of isRewardedLoaded
  updateIsRewardedLoaded(final bool newVal) {
    _isRewardedLoaded = newVal;
    notifyListeners();
  }

  // update value of isBannerLoaded
  updateIsBannerLoaded(final bool newVal) {
    _isBannerLoaded = newVal;
    notifyListeners();
  }

  // update value of bannerTries
  updateBannerTries(final int newVal) {
    _bannerTries = newVal;
    notifyListeners();
  }
}
