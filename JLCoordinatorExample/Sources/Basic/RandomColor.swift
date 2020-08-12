// Copyright © 2020 Jamit Labs GmbH. All rights reserved.

import UIKit

enum RandomColor {
    static func choose() -> UIColor {
        let colors: [UIColor] = [.black, .blue, .brown, .cyan, .darkGray, .gray, .green, .magenta, .orange, .purple, .red, .white, .yellow]
        return colors.randomElement() ?? .white
    }
}
