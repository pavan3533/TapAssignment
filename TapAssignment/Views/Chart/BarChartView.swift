//
//  BarChartView.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

final class BarChartView: UIView {
    var monthlyData: [MonthlyData] = []

    override func draw(_ rect: CGRect) {
        guard !monthlyData.isEmpty else { return }

        let maxVal = monthlyData.map { $0.value }.max() ?? 1
        let barWidth: CGFloat = rect.width / CGFloat(monthlyData.count)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(UIColor.systemGreen.cgColor)

        for (i, data) in monthlyData.enumerated() {
            let x = CGFloat(i) * barWidth
            let heightRatio = CGFloat(data.value) / CGFloat(maxVal)
            let barHeight = rect.height * heightRatio
            let y = rect.height - barHeight
            let barRect = CGRect(x: x + 4, y: y, width: barWidth - 8, height: barHeight)
            context?.fill(barRect)
        }
    }
}
