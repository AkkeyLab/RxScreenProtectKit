//
//  ViewController.swift
//  RxScreenProtectKitExample
//
//  Created by AKIO on 2019/04/16.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxScreenProtectKit
import RxSwift
import UIKit

final class ViewController: UIViewController {
    // https://www.pakutaso.com
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var mainTextView: UITextView!
    @IBOutlet private weak var minificationFilterControl: UISegmentedControl!
    @IBOutlet private weak var magnificationFilterControl: UISegmentedControl!
    @IBOutlet private weak var scaleChanger: UISlider!
    @IBOutlet private weak var applyButton: UIButton!
    @IBOutlet private weak var scaleLabel: UILabel!
    @IBOutlet private weak var validSwitch: UISwitch!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .light
        }
        self.rx.isScreenRecord
            .bind(to: mainImageView.layer.rx.isMosaic)
            .disposed(by: bag)
        self.rx.isScreenRecord
            .bind(to: nameLabel.layer.rx.isMosaic)
            .disposed(by: bag)
        self.rx.isScreenRecord
            .bind(to: mainTextView.layer.rx.isMosaic)
            .disposed(by: bag)
        applyButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.mainImageView.layer.applyMosaic()
                self?.nameLabel.layer.applyMosaic()
                self?.mainTextView.layer.applyMosaic()
            })
            .disposed(by: bag)
        validSwitch.rx.value
            .subscribe(onNext: { isValid in
                ScreenProtectKit.shared.isValid = isValid
            })
            .disposed(by: bag)

        changeSettings()
    }

    func changeSettings() {
        let filterCase: [CALayerContentsFilter] = [.linear, .nearest, .trilinear]
        minificationFilterControl.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                ScreenProtectKit
                    .shared
                    .config(rasterizationScale: CGFloat(self.scaleChanger.value),
                            minificationFilter: filterCase[index],
                            magnificationFilter: filterCase[self.magnificationFilterControl.selectedSegmentIndex])
            })
            .disposed(by: bag)
        magnificationFilterControl.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                ScreenProtectKit
                    .shared
                    .config(rasterizationScale: CGFloat(self.scaleChanger.value),
                            minificationFilter: filterCase[self.minificationFilterControl.selectedSegmentIndex],
                            magnificationFilter: filterCase[index])
            })
            .disposed(by: bag)
        scaleChanger.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                ScreenProtectKit
                    .shared
                    .config(rasterizationScale: CGFloat(self.scaleChanger.value),
                            minificationFilter: filterCase[self.minificationFilterControl.selectedSegmentIndex],
                            magnificationFilter: filterCase[self.magnificationFilterControl.selectedSegmentIndex])
                self.scaleLabel.text = "\(value)"
            })
            .disposed(by: bag)
    }
}
