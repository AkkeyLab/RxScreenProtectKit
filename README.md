<img src="https://github.com/AkkeyLab/RxScreenProtectKit/blob/master/Resources/logo.png?raw=true" alt="Miss Electric Eel 2016" width="36" height="36"> RxScreenProtectKit
======================================
[![RxScreenProtectKit](https://cocoapod-badges.herokuapp.com/v/RxScreenProtectKit/badge.png)](https://cocoapods.org/pods/RxScreenProtectKit)
![ios](https://cocoapod-badges.herokuapp.com/p/RxScreenProtectKit/badge.png)
![MIT](https://cocoapod-badges.herokuapp.com/l/RxScreenProtectKit/badge.png)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.com/AkkeyLab/RxScreenProtectKit.svg?branch=master)](https://travis-ci.com/AkkeyLab/RxScreenProtectKit)
[![codecov](https://codecov.io/gh/AkkeyLab/RxScreenProtectKit/branch/master/graph/badge.svg)](https://codecov.io/gh/AkkeyLab/RxScreenProtectKit)

Protect private content from screen recordings and screen output.  
Screen Recording / QuickTime Recording / External display output / AirPlay

<div align="center">
<img src="https://github.com/AkkeyLab/RxScreenProtectKit/blob/master/Resources/mock-normal.png?raw=true" width="260"/> <img src="https://github.com/AkkeyLab/RxScreenProtectKit/blob/master/Resources/mock-mosaic-A.png?raw=true" width="260"/> <img src="https://github.com/AkkeyLab/RxScreenProtectKit/blob/master/Resources/mock-mosaic-B.png?raw=true" width="260"/>
</div>

# Installation
#### CocoaPods
```ruby
# Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    pod 'RxScreenProtectKit'
end
```
Replace YOUR_TARGET_NAME and then, in the Podfile directory, type:
```sh
$ pod install
```

#### Carthage
Add this to `Cartfile`.
```ruby
# Cartfile
github "AkkeyLab/RxScreenProtectKit"
```
Run this script to install it.
```sh
$ carthage update --platform iOS
```

# Usage
If you use the example, please do the setup process with the shell script.
```sh
./setup.sh
```
Please import RxScreenProtectKit and RxSwift.
```swift
import RxScreenProtectKit
import RxSwift
import UIKit
```
By binding the target layer to isScreenRecord, mosaic processing is applied during screen recording or screen output. However, the layer must be compliant with CALayer.
```swift
final class ViewController: UIViewController {
    @IBOutlet private weak var mainImageView: UIImageView!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rx.isScreenRecord
            .bind(to: mainImageView.layer.rx.isMosaic)
            .disposed(by: bag)
    }
}
```
Parameter settings related to mosaic processing can be done from `ScreenProtectKit.shared.config()`.
```swift
ScreenProtectKit
    .shared
    .config(rasterizationScale: 0.1,
            minificationFilter: .trilinear,
            magnificationFilter: .nearest)
```
Moreover, it can be easily implemented by using SPImageView. This is particularly useful when images are set asynchronously.
```swift
final class ViewController: UIViewController {
    @IBOutlet private weak var mainImageView: SPImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.mainImageView.image = UIImage(named: "sample")
        }
    }
}
```
Also, by using SPLabel, you can easily implement character substitution during recording. All you need to do is set the text to be displayed during recording in `protectText`.
```swift
final class ViewController: UIViewController {
    @IBOutlet private weak var label: SPLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "This is the original text."
        label.protectText = "Recording is prohibited!!"
    }
}
```

# Settings
You can temporarily disable this feature. In addition, it returns to the valid state by restarting the app.  
`isScreenRecord` will not flow while this setting is disabled.  
When the value of this setting is changed, `isScreenRecord` will flow only once. When changed to invalid, false will flow, and when changed to valid, the current recording status will flow.
```swift
ScreenProtectKit
    .shared
    .isValid = isValid
```

# Requirements
|env  |version |
|---    |---   |
|Swift  |5.x   |
|Xcode  |11.x  |
|iOS    |11.0  |

# License
RxScreenProtectKit is available under the MIT license. See the LICENSE file for more info.
