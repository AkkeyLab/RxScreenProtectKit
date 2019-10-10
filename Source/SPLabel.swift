//
//  SPLabel.swift
//  RxScreenProtectKit
//
//  Created by AKIO on 2019/10/10.
//  Copyright © 2019 AKIO. All rights reserved.
//

import RxSwift
import UIKit

public final class SPLabel: UILabel {
    private var load = PublishSubject<Void>()
    private var original: String?
    /// Specify the character string to be replaced during recording.
    /// If nothing is specified, `nil` is assigned to `text` when a recording is detected.
    public var protectText: String?
    /// The current text that is displayed by the label.
    /// Please note that when recording, a different string will be returned from the original string.
    override public var text: String? {
        set {
            super.text = newValue
            original = newValue
            if newValue != nil {
                load.onNext(())
            }
        }
        get {
            return super.text
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private lazy var setup: (() -> Void) = {
        _ = Observable.of(
            self.rx.isScreenRecord.map { _ in () },
            load
            )
            .merge()
            .withLatestFrom(self.rx.isScreenRecord)
            .takeUntil(self.rx.deallocated)
            .subscribe(onNext: { [weak self] isScreenRecord in
                guard let self = self else { return }
                self.internalChanges(text: isScreenRecord ? self.protectText : self.original)
            })
        return {}
    }()

    private func internalChanges(text: String?) {
        super.text = text
    }
}
