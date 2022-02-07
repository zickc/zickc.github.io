//
//  UIView+Ext.swift
//  AppUtility
//
//  Created by zick on 2020/6/2.
//

#if canImport(SnapKit)

import UIKit.UIView
import SnapKit

// Ref. https://github.com/SnapKit/SnapKit/issues/448

public extension UIView {

    var safeArea: ConstraintBasicAttributesDSL {
        return self.safeAreaLayoutGuide.snp
    }
}

#endif
