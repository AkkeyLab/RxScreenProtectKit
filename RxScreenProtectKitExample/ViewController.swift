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
    private let bag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        isScreenRecord
            .bind(to: mainImageView.layer.rx.isMosaic)
            .disposed(by: bag)
    }
}

extension ViewController: Mosaicable {}
