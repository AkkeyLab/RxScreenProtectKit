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
Implementing Mosaicable enables you to call isScreenRecord.
```swift
extension ViewController: Mosaicable {}
```
By binding the target layer to isScreenRecord, mosaic processing is applied during screen recording or screen output. However, the layer must be compliant with CALayer.
```swift
final class ViewController: UIViewController {
    @IBOutlet private weak var mainImageView: UIImageView!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        isScreenRecord
            .bind(to: mainImageView.layer.rx.isMosaic)
            .disposed(by: bag)
    }
}
```
Parameter settings related to mosaic processing can be done from `ScreenProtectKit.config()`.
```swift
ScreenProtectKit
    .shared
    .config(rasterizationScale: 0.1,
            minificationFilter: .trilinear,
            magnificationFilter: .nearest)
```

# Requirements
|env  |version |
|---    |---   |
|Swift  |5.0   |
|Xcode  |10.2  |
|iOS    |11.0  |

# License
RxScreenProtectKit is available under the MIT license. See the LICENSE file for more info.
