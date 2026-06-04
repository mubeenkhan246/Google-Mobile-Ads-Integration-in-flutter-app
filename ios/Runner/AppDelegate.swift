import Flutter
import google_mobile_ads
import UIKit

final class ListTileNativeAdFactory: NSObject, FLTNativeAdFactory {
  func createNativeAd(_ nativeAd: NativeAd, customOptions: [AnyHashable: Any]? = nil) -> NativeAdView? {
    let adView = NativeAdView()
    adView.backgroundColor = UIColor.systemBackground

    let iconView = UIImageView()
    iconView.translatesAutoresizingMaskIntoConstraints = false
    iconView.contentMode = .scaleAspectFit
    iconView.layer.cornerRadius = 8
    iconView.clipsToBounds = true

    let headlineLabel = UILabel()
    headlineLabel.translatesAutoresizingMaskIntoConstraints = false
    headlineLabel.font = .preferredFont(forTextStyle: .headline)
    headlineLabel.numberOfLines = 1

    let bodyLabel = UILabel()
    bodyLabel.translatesAutoresizingMaskIntoConstraints = false
    bodyLabel.font = .preferredFont(forTextStyle: .subheadline)
    bodyLabel.numberOfLines = 2
    bodyLabel.textColor = .secondaryLabel

    let advertiserLabel = UILabel()
    advertiserLabel.translatesAutoresizingMaskIntoConstraints = false
    advertiserLabel.font = .preferredFont(forTextStyle: .caption1)
    advertiserLabel.textColor = .tertiaryLabel

    let callToActionButton = UIButton(type: .system)
    callToActionButton.translatesAutoresizingMaskIntoConstraints = false
    callToActionButton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
    callToActionButton.backgroundColor = .systemGreen
    callToActionButton.tintColor = .white
    callToActionButton.layer.cornerRadius = 8
    callToActionButton.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    callToActionButton.isUserInteractionEnabled = false

    let textStack = UIStackView(arrangedSubviews: [headlineLabel, bodyLabel, advertiserLabel])
    textStack.translatesAutoresizingMaskIntoConstraints = false
    textStack.axis = .vertical
    textStack.spacing = 4

    adView.addSubview(iconView)
    adView.addSubview(textStack)
    adView.addSubview(callToActionButton)

    NSLayoutConstraint.activate([
      iconView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: 12),
      iconView.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
      iconView.widthAnchor.constraint(equalToConstant: 56),
      iconView.heightAnchor.constraint(equalToConstant: 56),

      textStack.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
      textStack.centerYAnchor.constraint(equalTo: adView.centerYAnchor),
      textStack.trailingAnchor.constraint(lessThanOrEqualTo: callToActionButton.leadingAnchor, constant: -12),

      callToActionButton.trailingAnchor.constraint(equalTo: adView.trailingAnchor, constant: -12),
      callToActionButton.centerYAnchor.constraint(equalTo: adView.centerYAnchor)
    ])

    headlineLabel.text = nativeAd.headline
    bodyLabel.text = nativeAd.body
    bodyLabel.isHidden = nativeAd.body == nil
    advertiserLabel.text = nativeAd.advertiser
    advertiserLabel.isHidden = nativeAd.advertiser == nil
    iconView.image = nativeAd.icon?.image
    iconView.isHidden = nativeAd.icon == nil
    callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
    callToActionButton.isHidden = nativeAd.callToAction == nil

    adView.headlineView = headlineLabel
    adView.bodyView = bodyLabel
    adView.iconView = iconView
    adView.advertiserView = advertiserLabel
    adView.callToActionView = callToActionButton
    adView.nativeAd = nativeAd

    return adView
  }
}

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
      self,
      factoryId: "listTile",
      nativeAdFactory: ListTileNativeAdFactory()
    )
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
