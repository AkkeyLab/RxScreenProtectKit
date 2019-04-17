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
    @IBOutlet private weak var filterSelecter: UISegmentedControl!
    @IBOutlet private weak var scaleChanger: UISlider!
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        isScreenRecord
            .bind(to: mainImageView.layer.rx.isMosaic)
            .disposed(by: bag)
        isScreenRecord
            .bind(to: nameLabel.layer.rx.isMosaic)
            .disposed(by: bag)
        isScreenRecord
            .bind(to: mainTextView.layer.rx.isMosaic)
            .disposed(by: bag)

        let filterCase: [CALayerContentsFilter] = [.linear, .nearest, .trilinear]
        filterSelecter.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                let type = MosaicType(isValid: true, filter: filterCase[index])
                self?.mainImageView.layer.mosaicType = type
                self?.nameLabel.layer.mosaicType = type
                self?.mainTextView.layer.mosaicType = type
            })
            .disposed(by: bag)
        scaleChanger.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                let type = MosaicType(isValid: true, scale: CGFloat(value))
                self?.mainImageView.layer.mosaicType = type
                self?.nameLabel.layer.mosaicType = type
                self?.mainTextView.layer.mosaicType = type
            })
            .disposed(by: bag)
    }
}

extension ViewController: Mosaicable {}
