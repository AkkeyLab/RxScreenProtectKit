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

        let filterCase: [ScreenProtectKit.FilterType] = [.linear, .nearest, .trilinear]
        filterSelecter.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                ScreenProtectKit.config(filter: filterCase[index], scale: self.scaleChanger.value)
            })
            .disposed(by: bag)
        scaleChanger.rx.value
            .skip(1)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                ScreenProtectKit.config(filter: filterCase[self.filterSelecter.selectedSegmentIndex], scale: value)
            })
            .disposed(by: bag)
    }
}

extension ViewController: Mosaicable {}
