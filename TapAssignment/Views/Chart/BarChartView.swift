//
//  BarChartView.swift
//  TapAssignment
//
//  Created by Pavan Javali on 11/07/25.
//

import Foundation

import UIKit

final class BarChartView: UIView {

    var monthlyData: [MonthlyData] = [] {
        didSet {
            layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            drawChart()
        }
    }

    private let barColor = UIColor.systemBlue.cgColor
    private let spacing: CGFloat = 8

    private func drawChart() {
        guard !monthlyData.isEmpty else { return }

        let maxVal = monthlyData.map { $0.value }.max() ?? 1
        let chartHeight = bounds.height - 20 // Padding for labels

        let barWidth = (bounds.width - spacing * CGFloat(monthlyData.count + 1)) / CGFloat(monthlyData.count)

        for (index, data) in monthlyData.enumerated() {
            let x = spacing + CGFloat(index) * (barWidth + spacing)
            let heightRatio = CGFloat(data.value) / CGFloat(maxVal)
            let barHeight = chartHeight * heightRatio
            let y = bounds.height - barHeight

            let bar = CALayer()
            bar.frame = CGRect(x: x, y: bounds.height, width: barWidth, height: 0)
            bar.backgroundColor = barColor
            layer.addSublayer(bar)

            // Animate bar growing
            let animation = CABasicAnimation(keyPath: "bounds.size.height")
            animation.fromValue = 0
            animation.toValue = barHeight
            animation.duration = 0.4
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            bar.add(animation, forKey: "grow")

            // Apply final height after animation
            bar.frame = CGRect(x: x, y: y, width: barWidth, height: barHeight)

            // Add month label
            let label = UILabel()
            label.text = data.month
            label.font = .systemFont(ofSize: 10)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            label.frame = CGRect(x: x, y: bounds.height - 16, width: barWidth, height: 12)
            addSubview(label)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        subviews.forEach { $0.removeFromSuperview() }
        drawChart()
    }
}
