//
//  ContentView.swift
//  GreenTrack
//
//  Created by Adya Daruka on 25/12/24.
//

import Combine
import Foundation
import SwiftUI
import Charts

struct ThemeColors {
    static let primary = Color(red: 0.13, green: 0.55, blue: 0.13)    // Forest Green
    static let secondary = Color(red: 0.56, green: 0.74, blue: 0.56)  // Sage Green
    static let accent = Color(red: 0.0, green: 0.39, blue: 0.0)       // Dark Green
    static let warning = Color(red: 0.85, green: 0.37, blue: 0.01)    // Rust Orange
    static let background = Color(red: 0.95, green: 0.98, blue: 0.95) // Light Mint
    static let text = Color(red: 0.13, green: 0.27, blue: 0.13)       // Deep Forest
}

//testing git changes
//

// Enum to track view state
enum ViewState {
    case loading
    case introText
    case cards
    case infoPage
    case chatbot
}

// Message model
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    var options: [String]?
}

// InfoPage structure
struct InfoPage: Identifiable {
    let id = UUID()
    let title: String
    let content: String
    let imageSymbol: String
}

// Card structure
struct Card: Identifiable {
    let id = UUID()
    var content: String
    var leftChoice: String?
    var rightChoice: String?
}

// Negative AI quiz + game page
struct AINegativeImpact: View {
    @State private var currentQuizQuestion = 0
        @State private var score = 0
        @State private var showingWelcome = true
        @State private var showingQuiz = false
        @State private var showingTransition = false
        @State private var showingGame = false
        @State private var gameScore = 0
        @State private var selectedAnswer: Int?
        @State private var showExplanation = false
        @State private var currentDecision = 0
        @State private var showFinalScore = false
    
    let questions = [
        QuizQuestion(
            text: "How much carbon does training a large AI model emit?",
            options: [
                "10 tons of CO2",
                "100 tons of CO2",
                "626 tons of CO2",
                "1,000 tons of CO2"
            ],
            correctAnswer: 2,
            explanation: "Training a large AI model can emit about 626 tons of CO2, equivalent to 5 cars' lifetime emissions."
        ),
        QuizQuestion(
            text: "What percentage of global energy consumption is attributed to data centers?",
            options: [
                "1%",
                "2%",
                "5%",
                "10%"
            ],
            correctAnswer: 0,
            explanation: "Data centers currently use about 1% of global electricity, but this is growing rapidly."
        ),
        QuizQuestion(
            text: "What is the primary source of energy for AI systems, and why is it harmful?",
            options: [
                "Solar energy; it's inefficient for AI systems",
                "Wind energy; it generates too little power",
                "Fossil fuels; they produce greenhouse gas emissions",
                "Nuclear energy; it's too costly"
            ],
            correctAnswer: 2,
            explanation: "Fossil fuels produce greenhouse gas emissions which harm our ozone layer."
        ),
        QuizQuestion(
            text: "What is one significant environmental problem caused by the mining of materials for AI hardware?",
            options: [
                "Overpopulation",
                "Soil erosion and pollution",
                "Lack of electricity",
                "Excessive rainfall"
            ],
            correctAnswer: 1,
            explanation: "Mining metals for AI hardware cause soil erosion and pollution."
        ),
        QuizQuestion(
            text: "True or False: AI applications cannot have any positive environmental benefits.",
            options: [
                "True",
                "False"
            ],
            correctAnswer: 1,
            explanation: "False. AI applications can have positive environmental benefits when designed and implemented sustainably."
        )
    ]
    
    let decisions = [
        GameDecision(
            text: "Choose your AI Model size:",
            options: [
                "Small, Specialized Model",
                "Medium-Sized Model",
                "Large, General-Purpose Model"
            ],
            impacts: [
                Impact(sustainability: 30, note: "Consumes minimal energy and resources."),
                Impact(sustainability: 10, note: "Balances performance with energy consumption."),
                Impact(sustainability: -20, note: "Requires significant computational power and energy.")
            ],
            educationalNote: "Training large AI models demands an enormous amount of energy. For instance, training GPT-3 produced approximately 552 metric tons of CO₂ equivalent during its training phase alone."
        ),
        GameDecision(
            text: "Select your Data Center Location:",
            options: [
                "Region with Abundant Renewable Energy",
                "Region with Mixed Energy Sources",
                "Region Dependent on Fossil Fuels"
            ],
            impacts: [
                Impact(sustainability: 30, note: "Lower carbon footprint due to cleaner energy mix."),
                Impact(sustainability: 10, note: "Moderate carbon emissions."),
                Impact(sustainability: -20, note: "Higher carbon emissions.")
            ],
            educationalNote: "The carbon intensity of electricity varies by region. Locating data centers in areas with a higher share of renewable energy can significantly reduce carbon emissions."
        ),
        GameDecision(
            text: "Choose your Data Center Size:",
            options: [
                "Small Scale",
                "Medium Scale",
                "Large Scale"
            ],
            impacts: [
                Impact(sustainability: 20, note: "Lower energy consumption but may limit AI capabilities."),
                Impact(sustainability: 10, note: "Balances capacity with energy usage."),
                Impact(sustainability: -20, note: "Higher energy consumption to support advanced AI models.")
            ],
            educationalNote: "Larger data centers consume more energy, contributing to higher carbon emissions. Balancing size with efficiency is crucial for sustainability."
        ),
        GameDecision(
            text: "Select your Cooling System:",
            options: [
                "Air-Based Cooling",
                "Water-Based Cooling",
                "Advanced Cooling Technologies"
            ],
            impacts: [
                Impact(sustainability: 20, note: "Less water usage but may be less efficient in certain climates."),
                Impact(sustainability: -10, note: "Effective but consumes large amounts of water."),
                Impact(sustainability: 30, note: "Highly efficient with reduced environmental impact.")
            ],
            educationalNote: "Data centers can consume millions of gallons of water daily for cooling purposes. Implementing advanced cooling technologies can enhance efficiency and reduce environmental impact."
        ),
        GameDecision(
            text: "Choose your Hardware:",
            options: [
                "Energy-Efficient Hardware",
                "Standard Hardware",
                "High-Performance Hardware without Efficiency Considerations"
            ],
            impacts: [
                Impact(sustainability: 25, note: "Reduces overall energy consumption."),
                Impact(sustainability: 10, note: "Moderate energy usage."),
                Impact(sustainability: -20, note: "High energy usage.")
            ],
            educationalNote: "Implementing energy-efficient hardware can significantly lower the environmental impact of data centers."
        ),
        GameDecision(
            text: "Select Operational Practices:",
            options: [
                "Implement AI for Energy Management",
                "Standard Operations with Periodic Audits",
                "Standard Operations without Energy Optimization"
            ],
            impacts: [
                Impact(sustainability: 20, note: "Optimizes energy use, enhancing efficiency."),
                Impact(sustainability: 10, note: "Somewhat optimized energy management."),
                Impact(sustainability: -20, note: "Lacks optimized energy management.")
            ],
            educationalNote: "AI can be utilized to optimize energy consumption in data centers, contributing to sustainability efforts."
        )
    ]
    
    func getSustainabilityFeedback(_ score: Int) -> (String, Color) {
        switch score {
        case 120...150:
            return ("Outstanding! Your AI model and data center design are highly sustainable, demonstrating a strong commitment to environmental responsibility.", .green)
        case 80...119:
            return ("Good job! Your design incorporates several sustainable choices, though there's room for improvement in certain areas.", .blue)
        case 40...79:
            return ("Your design has some sustainable elements, but significant enhancements are needed to reduce environmental impact.", .orange)
        default:
            return ("Your design lacks sustainability considerations, leading to a high environmental impact. Re-evaluating your choices could lead to more eco-friendly outcomes.", .red)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if showingWelcome {
                            // Welcome Screen
                            VStack(spacing: 30) {
                                Text("Welcome to Test Your Knowledge!")
                                    .font(.title)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Text("Click the start quiz button to test your understanding of AI's Effect on our environment")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Text("After the quiz, you can implement all that you have learned and design your own hypothetical AI model and data center and recognize the impact of design choices on sustainability!")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Button(action: {
                                    withAnimation {
                                        showingWelcome = false
                                        showingQuiz = true
                                    }
                                }) {
                                    Text("Start Quiz")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(ThemeColors.primary)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
            
            if showingQuiz {
                // Quiz View
                VStack(spacing: 20) {
                    Text("AI vs. Climate Quiz")
                        .font(.title)
                        .bold()
                    
                    Text("Question \(currentQuizQuestion + 1) of \(questions.count)")
                        .font(.subheadline)
                    
                    Text("Score: \(score)")
                        .font(.headline)
                    
                    Text(questions[currentQuizQuestion].text)
                        .font(.body)
                        .padding()
                        .multilineTextAlignment(.center)
                    
                    ForEach(0..<questions[currentQuizQuestion].options.count, id: \.self) { index in
                        Button(action: {
                            selectedAnswer = index
                            showExplanation = true
                            if index == questions[currentQuizQuestion].correctAnswer {
                                score += 1
                            }
                        }) {
                            Text(questions[currentQuizQuestion].options[index])
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedAnswer == index ? ThemeColors.primary : ThemeColors.secondary)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(showExplanation)
                    }
                    
                    if showExplanation {
                        Text(questions[currentQuizQuestion].explanation)
                            .padding()
                            .background(ThemeColors.secondary.opacity(0.2))
                            .cornerRadius(10)
                        
                        Button("Next") {
                            if currentQuizQuestion < questions.count - 1 {
                                currentQuizQuestion += 1
                                selectedAnswer = nil
                                showExplanation = false
                            } else {
                                showingQuiz = false
                                showingGame = true
                            }
                        }
                        .padding()
                        .background(ThemeColors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            if showingTransition {
                            // Transition Screen
                            VStack(spacing: 30) {
                                Text("Great job completing the quiz!")
                                    .font(.title)
                                    .bold()
                                    .multilineTextAlignment(.center)
                                
                                Text("Now you have the chance to utilize all that you have learned to design your own hypothetical AI model and data center to understand the impact of design choices on its sustainability!")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                
                                Button(action: {
                                    withAnimation {
                                        showingTransition = false
                                        showingGame = true
                                    }
                                }) {
                                    Text("Start Design Challenge")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(ThemeColors.primary)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
            
            if showingGame {
                // Game View
                ScrollView {
                    VStack(spacing: 20) {
                        if showFinalScore {
                            let (feedback, color) = getSustainabilityFeedback(gameScore)
                            Text("Final Sustainability Score: \(gameScore)")
                                .font(.title2)
                                .bold()
                            
                            Text(feedback)
                                .padding()
                                .background(color.opacity(0.2))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                            
                            Button("Start Over") {
                                showFinalScore = false
                                showingQuiz = true
                                showingGame = false
                                currentQuizQuestion = 0
                                score = 0
                                gameScore = 0
                                currentDecision = 0
                            }
                            .padding()
                            .background(ThemeColors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        } else {
                            Text("Sustainability Decision Game")
                                .font(.title)
                                .bold()
                            
                            Text("Current Score: \(gameScore)")
                                .font(.headline)
                            
                            Text(decisions[currentDecision].text)
                                .font(.body)
                                .padding()
                                .multilineTextAlignment(.center)
                            
                            ForEach(0..<decisions[currentDecision].options.count, id: \.self) { index in
                                Button(action: {
                                    let impact = decisions[currentDecision].impacts[index]
                                    gameScore += impact.sustainability
                                    
                                    if currentDecision < decisions.count - 1 {
                                        currentDecision += 1
                                    } else {
                                        showFinalScore = true
                                    }
                                }) {
                                    VStack(spacing: 8) {
                                        Text(decisions[currentDecision].options[index])
                                            .multilineTextAlignment(.center)
                                        Text(decisions[currentDecision].impacts[index].note)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(ThemeColors.primary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                            }
                            
                            Text("Educational Note:")
                                .font(.headline)
                                .padding(.top)
                            Text(decisions[currentDecision].educationalNote)
                                .font(.caption)
                                .padding()
                                .background(ThemeColors.primary.opacity(0.1))
                                .cornerRadius(10)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct QuizQuestion {
    let text: String
    let options: [String]
    let correctAnswer: Int
    let explanation: String
}

struct GameDecision {
    let text: String
    let options: [String]
    let impacts: [Impact]
    let educationalNote: String
}

struct Impact {
    let sustainability: Int
    let note: String
}
struct TimelineMetrics: Identifiable {
    let id = UUID()
    let year: Int
    let efficiency: Double
    let emissions: Double
    let waste: Double
}

struct ComparisonMetrics: Identifiable {
    let id = UUID()
    let year: Int
    let efficiencyWithAI: Double
}

// AI Efficiency page
struct AIEfficiencyPage: View {
    @State private var activeCard: Int? = nil
    @State private var selectedYear: Double = 2024
    @State private var showLineChart = true
    @State private var userEnergyUsage: String = ""
    @State private var calculatedCarbonFootprint: Double? = nil

    let timelineData: [TimelineMetrics] = [
           TimelineMetrics(year: 2020, efficiency: 20, emissions: 100, waste: 80),
           TimelineMetrics(year: 2021, efficiency: 35, emissions: 85, waste: 70),
           TimelineMetrics(year: 2022, efficiency: 55, emissions: 65, waste: 55),
           TimelineMetrics(year: 2023, efficiency: 75, emissions: 45, waste: 35),
           TimelineMetrics(year: 2024, efficiency: 90, emissions: 25, waste: 15),
       ]
    let comparisonData: [ComparisonMetrics] = [
           ComparisonMetrics(year: 2020, efficiencyWithAI: 10.0),
           ComparisonMetrics(year: 2030, efficiencyWithAI: 9.7),
           ComparisonMetrics(year: 2040, efficiencyWithAI: 9.5),
           ComparisonMetrics(year: 2050, efficiencyWithAI: 9.0)
       ]

    let benefits: [Benefit] = [
        Benefit(id: 1, title: "Supply Chain Optimization", description: "AI algorithms revolutionize supply chain management.", details: [
            BenefitDetail(title: "Route Optimization", description: "AI analyzes traffic patterns to reduce transportation emissions by up to 30%.")
        ]),
        Benefit(id: 2, title: "Reduced Production Waste", description: "Smart manufacturing systems minimize waste.", details: [
            BenefitDetail(title: "Predictive Maintenance", description: "AI predicts equipment failures, reducing downtime by 45%.")
        ]),
        Benefit(id: 3, title: "Energy Efficiency", description: "Optimizes energy consumption through adaptive controls.", details: [
            BenefitDetail(title: "Smart Grid Management", description: "Balances power distribution, reducing energy waste by 20%.")
        ])
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    Text("AI for a Sustainable Future")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
                }
                Text("Discover how cutting-edge AI technology is transforming the fight against climate change and revolutionizing sustainability. From optimizing energy efficiency to reducing waste and streamlining supply chains, AI is unlocking innovative solutions for a greener planet. Dive into real-world case studies, explore efficiency trends, and learn how you can leverage AI to make a positive environmental impact. Together, we can build a more sustainable future through intelligent technology.")
                    .font(.body)

                // Timeline Explorer
                                VStack(spacing: 20) {
                                    Text("Timeline Explorer")
                                        .font(.headline)
                                    Text("Explore significant milestones in AI's impact on sustainability!")

                                    HStack {
                                        Text("Year: \(Int(selectedYear))")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    .padding(.horizontal)

                                    Slider(value: $selectedYear, in: 2020...2024, step: 1)
                                        .padding(.horizontal)

                                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                        MetricView(title: "Efficiency Gain", value: getTimelineMetrics(for: selectedYear).efficiency, unit: "%")
                                        MetricView(title: "Emissions Reduction", value: 100 - getTimelineMetrics(for: selectedYear).emissions, unit: "%")
                                        MetricView(title: "Waste Reduction", value: 100 - getTimelineMetrics(for: selectedYear).waste, unit: "%")
                                    }
                                }

                // Efficiency Comparison Trends
                                VStack {
                                    Text("Carbon Emissions Over the Next 30 Years")
                                        .font(.headline)

                                    Picker("Chart Type", selection: $showLineChart) {
                                        Text("Line Chart").tag(true)
                                        Text("Bar Chart").tag(false)
                                    }
                                    .pickerStyle(SegmentedPickerStyle())
                                    .padding()

                                    if showLineChart {
                                        Chart {
                                            ForEach(comparisonData) { metric in
                                                LineMark(
                                                    x: .value("Year", metric.year),
                                                    y: .value("With AI", metric.efficiencyWithAI)
                                                )
                                                .foregroundStyle(ThemeColors.primary)
                                                .interpolationMethod(.linear)
                                                
                                            }
                                            .foregroundStyle(ThemeColors.primary)
                                            
                                            
                                        }
                                            
                                        .frame(height: 200)
                                        .chartYScale(domain: 8.5...10.5)
                                        .chartXScale(domain: 2020...2050)
                                        
                                        HStack {
                                            HStack {
                                                Circle()
                                                    .fill(ThemeColors.primary)
                                                    .frame(width: 10, height: 10)
                                                Text("With AI")
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal)
                                            
                                        }
                                    } else {
                                        Chart {
                                            ForEach(comparisonData) { metric in
                                                BarMark(
                                                    x: .value("Year", "\(metric.year)"),
                                                    y: .value("With AI", metric.efficiencyWithAI)
                                                )
                                                .foregroundStyle(ThemeColors.primary)
                                                .position(by: .value("Type", "With AI"))
                                                
                                        
                                            }
                                        }
                                        .frame(height: 200)
                                        .chartYScale(domain: 8.5...10.5)
                                        .chartXScale(domain: 2020...2050)
                                        
                                        // Legend
                                        HStack {
                                            HStack {
                                                Rectangle()
                                                    .fill(ThemeColors.primary)
                                                    .frame(width: 20, height: 10)
                                                Text("With AI")
                                                    .font(.caption)
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    Text("Multiple studies have predicted the average carbon emitted for energy production will decrease over the next couple of decades due to the widespread use of Artificial Intelligence.")
                                }

                // User Input Section
                VStack(spacing: 16) {
                    Text("Calculate a Carbon Footprint")
                        .font(.headline)
                    Text("Input a hypothetical value and see how it translates into a carbon footprint!")
                        .font(.headline)

                    TextField("Yearly energy usage (kWh)", text: $userEnergyUsage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .padding(.horizontal)

                    Button(action: calculateCarbonFootprint) {
                        Text("Calculate")
                            .font(.custom("Avenir-Heavy", size: 18))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ThemeColors.primary)
                            .cornerRadius(10)
                    }

                    if let footprint = calculatedCarbonFootprint {
                        Text("Your Carbon Footprint: \(footprint, specifier: "%.2f") tonnes CO2")
                            .font(.body)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
                .padding()
                .background(ThemeColors.background)
                .cornerRadius(10)

                // Benefits Section
                VStack(spacing: 16) {
                    Text("Key Benefits of Implementing AI for Sustainability")
                        .font(.headline)

                    ForEach(benefits) { benefit in
                        BenefitCard(benefit: benefit, isActive: activeCard == benefit.id) {
                            activeCard = activeCard == benefit.id ? nil : benefit.id
                        }
                    }
                }

                // Real-World Case Studies
                VStack(alignment: .leading, spacing: 16) {
                    Text("Real-World Case Studies")
                        .font(.headline)

                    ForEach(0..<3, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            if index == 0 {
                                Text("Google's AI-Driven Data Center Optimization")
                                    .font(.subheadline)
                                    .bold()
                                Text("Google implemented DeepMind's AI to optimize cooling systems in its data centers, achieving a 40% reduction in energy used for cooling and a 15% improvement in overall energy efficiency.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            } else if index == 1 {
                                Text("Winnow's AI-Powered Food Waste Reduction")
                                    .font(.subheadline)
                                    .bold()
                                Text("Winnow utilizes AI to help commercial kitchens track and reduce food waste, leading to significant cost savings and a decrease in environmental impact.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            } else if index == 2 {
                                Text("Agricarbon's Automated Soil Carbon Measurement")
                                    .font(.subheadline)
                                    .bold()
                                Text("Agricarbon employs AI-driven automated soil analysis to enhance regenerative agriculture practices, improving soil health and carbon sequestration.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
                .padding()

            }
            .padding()
        }
    }

    private func getTimelineMetrics(for year: Double) -> TimelineMetrics {
        timelineData.first { $0.year == Int(year) } ?? TimelineMetrics(year: Int(year), efficiency: 0, emissions: 0, waste: 0)
    }

    private func calculateCarbonFootprint() {
        guard let energyUsage = Double(userEnergyUsage) else {
            calculatedCarbonFootprint = nil
            return
        }

        // Example calculation: carbon footprint = energy usage * conversion factor (0.0005)
        calculatedCarbonFootprint = energyUsage * 0.0005
    }
}

struct YearlyMetrics: Identifiable {
    let id = UUID()
    let year: Int
    let efficiency: Double
    let emissions: Double
    let waste: Double
}

struct Benefit: Identifiable {
    let id: Int
    let title: String
    let description: String
    let details: [BenefitDetail]
}

struct BenefitDetail: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct MetricView: View {
    let title: String
    let value: Double
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom("Avenir-Book", size: 14))
                .foregroundColor(ThemeColors.text)
            Text("\(Int(value))\(unit)")
                .font(.custom("Avenir-Heavy", size: 28))
                .foregroundColor(ThemeColors.primary)
                .bold()
        }
        .padding()
        .background(ThemeColors.background)
        .cornerRadius(8)
    }
}

struct BenefitCard: View {
    let benefit: Benefit
    let isActive: Bool
    let toggle: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(benefit.title)
                    .font(.custom("Avenir-Heavy", size: 20))
                    .foregroundColor(ThemeColors.primary)
                Spacer()
                Button(action: toggle) {
                    Image(systemName: isActive ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }
            Text(benefit.description)
                .font(.subheadline)
                .foregroundColor(.secondary)

            if isActive {
                VStack(spacing: 8) {
                    ForEach(benefit.details) { detail in
                        HStack {
                            Text(detail.title)
                                .bold()
                            Spacer()
                            Text(detail.description)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(ThemeColors.background)
        .cornerRadius(8)
    }
}

struct ChartSection<Data: Identifiable, Content: View>: View {
    let title: String
    let data: [Data]
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            content()
                .frame(height: 200)
        }
    }
}

//AI envornmentakl negative impact
struct EnvironmentalImpactPage: View {
    @State private var userEnergyUsage: String = ""
    @State private var calculatedCarbonFootprint: Double? = nil

    let keyStatistics: [KeyStatistic] = [
        KeyStatistic(title: "Carbon Emissions from Training GPT-3", value: "502 metric tons", description: "Equivalent to the annual emissions of 112 gasoline-powered cars."),
        KeyStatistic(title: "Energy Consumption for GPT-3 Training", value: "1,287 MWh", description: "Comparable to the yearly energy usage of 120 U.S. homes."),
        KeyStatistic(title: "Water Usage for Cooling Data Centers", value: "10 million liters", description: "Enough to fill four Olympic-sized swimming pools.")
    ]

    let caseStudies: [CaseStudy] = [
        CaseStudy(title: "Microsoft x Oil Extraction Companies", description: "ASome AI technologies have been employed to enhance the efficiency of fossil fuel extraction. Companies like Microsoft have marketed AI solutions to oil and gas corporations, aiding in more effective extraction processes. This application of AI contradicts environmental sustainability efforts, as it facilitates increased fossil fuel production, thereby exacerbating carbon emissions and hindering progress toward climate goals."),
        CaseStudy(title: "Data Centers' Strain on Local Resources", description: "The rapid expansion of AI-driven data centers has significantly increased energy consumption, straining local power grids and water resources. In Ireland, data centers accounted for 21% of the nation's electricity usage in 2023, surpassing the combined consumption of all urban households.  This surge has led to a greater reliance on fossil fuels, complicating efforts to reduce emissions and posing challenges to local infrastructure."),
        CaseStudy(title: "E-Waste Generation", description: "The rapid advancement of AI technologies necessitates frequent hardware upgrades, leading to increased electronic waste. The production and disposal of AI hardware contribute to environmental pollution and resource depletion. Additionally, the short lifespan of AI hardware accelerates the accumulation of e-waste, posing disposal challenges.")
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                HStack(spacing: 12) {
                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    Text("AI's Environmental Impact")
                        .font(.custom("Avenir-Heavy", size: 34))
                        .foregroundColor(ThemeColors.primary)
                        .bold()
                        .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top ?? 20)
                }
                .padding()
                
                Text("Artificial Intelligence (AI) has brought about significant advancements across various sectors, but it's crucial to recognize its environmental implications. This page delves into the negative environmental effects of AI, providing insights and data to foster a comprehensive understanding of its ecological footprint.")
                    .font(.custom("Avenir-Heavy", size: 16))
                    .padding()
                    .background(Color(ThemeColors.secondary))
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .padding(.horizontal, 16)
                // Key Statistics
                VStack(spacing: 16) {
                    Text("Key Statistics")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    ForEach(keyStatistics) { stat in
                        KeyStatisticView(statistic: stat)
                    }
                }
                .padding()
//                .background(ThemeColors.background)
                .cornerRadius(10)
                
                // User Input Section
                VStack(spacing: 16) {
                    
                    
                    // Case Studies
                    VStack(spacing: 16) {
                        Text("Real-World Case Studies")
                            .font(.headline)
                        
                        ForEach(caseStudies) { study in
                            CaseStudyView(caseStudy: study)
                        }
                    }
                    .padding()
                }
                .padding()
                VStack(spacing: 16) {
                    Text("Comparing AI Energy Consumption")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 8)
                    VStack(alignment: .leading, spacing: 8) {
                            Text("Spatial Concentration of AI Facilities")
                                .font(.headline)
                            Image("AIConcentration")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                            Text("This graph shows the spatial concentration of various facilities in the United States, highlighting the high concentration of data centers compared to other facilities. Such concentration strains local energy grids and resources.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
//                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                        // 2. Energy Consumption Per Request
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Energy Consumption Per Request")
                                .font(.headline)
                            Image("AISearch")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                            Text("This chart compares the energy consumption of different AI applications per request. It highlights the significant energy demands of AI-powered Google searches and models like ChatGPT and BLOOM.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        .cornerRadius(8)

                        // 3. Global Electricity Demand Trends
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Global Electricity Demand Trends")
                                .font(.headline)
                            Image("AIProjected")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                            Text("This graph illustrates the projected increase in global electricity demand from data centers, AI, and cryptocurrencies from 2019 to 2026. It emphasizes the need for efficiency improvements and renewable energy adoption.")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        
                        .cornerRadius(8)
                    }
                    .padding()
                VStack(spacing: 24) {
                    // Title
                    Text("Potential Solutions and Mitigation Strategies")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                    
                    // Energy-Efficient Algorithms
                    HStack(spacing: 16) {
                        Image(systemName: "bolt.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Energy-Efficient Algorithms")
                                .font(.headline)
                                .bold()
                            Text("Development of lightweight AI models that require less computational power.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            Text("Example: TinyML for energy-constrained applications.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    // Transition to Renewable Energy
                    HStack(spacing: 16) {
                        Image(systemName: "sun.max.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Transition to Renewable Energy")
                                .font(.headline)
                                .bold()
                            Text("Using solar, wind, or hydropower to fuel data centers.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            Text("Highlight companies committed to 100% renewable energy.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    // Water Recycling in Data Centers
                    HStack(spacing: 16) {
                        Image(systemName: "drop.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Water Recycling in Data Centers")
                                .font(.headline)
                                .bold()
                            Text("Adoption of closed-loop cooling systems to reduce water waste.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            Text("Example: Microsoft’s commitment to water-positive operations by 2030.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    // Green AI Initiatives
                    HStack(spacing: 16) {
                        Image(systemName: "leaf.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.green)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Green AI Initiatives")
                                .font(.headline)
                                .bold()
                            Text("Programs focusing on reducing AI's carbon footprint (e.g., EnergyStar-rated servers).")
                                .font(.body)
                                .foregroundColor(.secondary)
                            Text("AI models to monitor and optimize their energy consumption.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    // Policy and Regulation
                    HStack(spacing: 16) {
                        Image(systemName: "gavel")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.purple)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Policy and Regulation")
                                .font(.headline)
                                .bold()
                            Text("Governments incentivizing green technologies for data centers.")
                                .font(.body)
                                .foregroundColor(.secondary)
                            Text("Introduction of carbon credits for AI companies.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding()

            }
        }
    }
    
}

// Supporting Structures and Views
struct KeyStatistic: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let description: String
}

struct CaseStudy: Identifiable {
    let id = UUID()
    let title: String
    let description: String
}

struct KeyStatisticView: View {
    let statistic: KeyStatistic

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(statistic.title)
                .font(.headline)
            Text(statistic.value)
                .font(.custom("Avenir-Heavy", size: 32))
                    .foregroundColor(ThemeColors.warning)
            Text(statistic.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(ThemeColors.background)
        .cornerRadius(10)
    }
}

struct CaseStudyView: View {
    let caseStudy: CaseStudy

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(caseStudy.title)
                .font(.subheadline)
                .bold()
            Text(caseStudy.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(ThemeColors.background)
        .cornerRadius(8)
    }
}

// Data structures for OpenAI integration
struct OpenAIResponse: Codable {
    let choices: [Choice]
    
    struct Choice: Codable {
        let message: Message
        
        struct Message: Codable {
            let content: String
        }
    }
}

// Configuration for OpenAI
enum OpenAIConfig {
    static let apiKey = "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"
    static let endpoint = "https://api.openai.com/v1/chat/completions"  // Changed endpoint
    static let model = "gpt-4o-mini"  // Updated model
    static let maxTokens = 150
    static let temperature = 0.7
}

class ChatbotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var userInput: String = ""
    @Published var viewState: ViewState = .loading
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        startChat()
    }
    
    func startChat() {
        addBotMessage("Hi! I'm your Carbon Footprint Assistant. I'll help you understand your environmental impact and suggest improvements. Feel free to type your responses below.")
            
    }
    
    func addBotMessage(_ text: String) {
        messages.append(ChatMessage(text: text, isUser: false))
         
    }
    
    func addUserMessage() {
        guard !userInput.isEmpty else { return }
        let input = userInput
        messages.append(ChatMessage(text: userInput, isUser: true))
        userInput = ""
        askOpenAI(input)
    }
    
    private func askOpenAI(_ input: String) {
        addBotMessage("Thinking...")
        
        guard let url = URL(string: OpenAIConfig.endpoint) else {
            messages.removeLast()
            addBotMessage("Error: Invalid API endpoint")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(OpenAIConfig.apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Updated request body structure
        let body: [String: Any] = [
            "model": OpenAIConfig.model,
            "messages": [
                ["role": "system", "content": "You are a helpful carbon footprint assistant. Provide concise, practical advice about reducing environmental impact."],
                ["role": "user", "content": input]
            ],
            "max_tokens": OpenAIConfig.maxTokens,
            "temperature": OpenAIConfig.temperature
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            messages.removeLast()
            addBotMessage("Error preparing request: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.messages.removeLast() // Remove "Thinking..." message
                
                if let error = error {
                    self.addBotMessage("Error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.addBotMessage("Error: No response received from server")
                    return
                }
                
                // Print response for debugging
                if let responseString = String(data: data, encoding: .utf8) {
                    print("API Response:", responseString)
                }
                
                do {
                    let response = try JSONDecoder().decode(OpenAIResponse.self, from: data)
                    if let content = response.choices.first?.message.content {
                        self.addBotMessage(content)
                    } else {
                        self.addBotMessage("Error: No content returned from OpenAI")
                    }
                } catch {
                    self.addBotMessage("Error processing response: \(error.localizedDescription)")
                    print("Decoding error:", error)
                }
            }
        }.resume()
    }
}

struct ChatbotView: View {
    @StateObject private var viewModel = ChatbotViewModel()
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages Area with Scroll
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: true) {  // Added showsIndicators: true
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    scrollProxy = proxy
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        scrollProxy?.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Input Area
            VStack(spacing: 0) {
                Divider()
                HStack {
                    TextField("Type your message...", text: $viewModel.userInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.addUserMessage()
                        // Ensure keyboard doesn't interfere with scrolling
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                     to: nil, from: nil, for: nil)
                    }) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .disabled(viewModel.userInput.isEmpty)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
            }
        }
        .background(Color(.systemBackground))
    }
}

// Updated MessageView with improved layout
struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(message.isUser ? ThemeColors.primary : ThemeColors.secondary.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(20)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = message.text
                    }) {
                        Text("Copy")
                        Image(systemName: "doc.on.doc")
                    }
                }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
}


struct CardStack: View {
    @State private var viewState: ViewState = .loading
    @State private var currentWordIndex = -1  // Changed to start at -1
    @State private var words = ["The Future", "of AI", "Has Begun", "Now"]
    @State private var swipeHistory: [String] = []
    @State private var offset = CGSize.zero
    @State private var currentCard: Card? = Card(
        content: "How do you feel about AI?",
        leftChoice: "Concerned",
        rightChoice: "Optimistic"
    )
    @State private var currentInfoPage: AnyView? = nil
    @State private var previewChoice: String? = nil
    @State private var previewOpacity: Double = 0
    
    let decisionTree: [String: Card] = [
        "Concerned": Card(
            content: "What concerns you most?",
            leftChoice: "AI's Environmental Impact",
            rightChoice: "I don't know, Test me!"
        ),
        "Optimistic": Card(
            content: "What excites you most?",
            leftChoice: "Applications of AI",
            rightChoice: "Positive Sustainability Impact"
        )
    ]
    
    let infoPages: [String: AnyView] = [
        "AI's Environmental Impact": AnyView(EnvironmentalImpactPage()),
        "I don't know, Test me!": AnyView(AINegativeImpact()),
        "Positive Sustainability Impact": AnyView(AIEfficiencyPage())
    ]
    
    var body: some View {
            ZStack {
                switch viewState {
                case .loading:
                    LoadingView()
                case .introText:
                    if currentWordIndex >= 0 && currentWordIndex < words.count {
                        Text(words[currentWordIndex])
                            .font(.custom("Avenir-Heavy", size: 34))
                            .foregroundColor(ThemeColors.primary)
                            .transition(.move(edge: .bottom))
                    }
                case .cards:
                    if let card = currentCard {
                        ZStack {
                            if let preview = previewChoice {
                                Text(preview)
                                    .font(.title2)
                                    .foregroundColor(ThemeColors.primary)
                                    .opacity(previewOpacity)
                                    .offset(y: 220)
                                    .animation(.easeInOut(duration: 0.2), value: previewOpacity)
                            }
                            
                            CardView(card: card)
                                .offset(x: offset.width, y: offset.height)
                                .rotationEffect(.degrees(Double(offset.width / 10)))
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            offset = gesture.translation
                                            updatePreviewChoice(width: gesture.translation.width, card: card)
                                        }
                                        .onEnded { gesture in
                                            withAnimation {
                                                handleSwipe(width: gesture.translation.width, card: card)
                                                previewChoice = nil
                                                previewOpacity = 0
                                            }
                                        }
                                )
                        }
                    }
                case .infoPage:
                    if let info = currentInfoPage {
                        currentInfoPage
                            .transition(.opacity)
                    }
                    
                case .chatbot:
                    ChatbotView()
                        .transition(.opacity)
                }
            }
            .onAppear(perform: startSequence)
        }
        
        private func processChoice(choice: String?) {
            guard let choice = choice else { return }
            
            if choice == "Applications of AI" {
                withAnimation {
                    viewState = .chatbot
                }
            } else if let nextCard = decisionTree[choice] {
                currentCard = nextCard
            } else if let infoPageView = infoPages[choice] {
                currentInfoPage = infoPageView
                withAnimation {
                    viewState = .infoPage
                }
            }
        }
        
        
    private func updatePreviewChoice(width: CGFloat, card: Card) {
        let swipeThreshold: CGFloat = 50
        
        if width > swipeThreshold {
            previewChoice = card.rightChoice
            previewOpacity = min(1.0, Double(width - swipeThreshold) / 50)
        } else if width < -swipeThreshold {
            previewChoice = card.leftChoice
            previewOpacity = min(1.0, Double(-width - swipeThreshold) / 50)
        } else {
            resetPreview()
        }
    }

    private func resetPreview() {
        previewChoice = nil
        previewOpacity = 0
    }
    
    private func startSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                viewState = .introText
                animateWords()
            }
        }
    }
    
    private func animateWords() {
        let nextIndex = currentWordIndex + 1
        guard nextIndex < words.count else {
            showCards()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                currentWordIndex = nextIndex
                animateWords()
            }
        }
    }
    
    private func showCards() {
        withAnimation {
            viewState = .cards
        }
    }
    
    private func handleSwipe(width: CGFloat, card: Card) {
        let swipeThreshold: CGFloat = 100
        
        if width > swipeThreshold {
            processChoice(choice: card.rightChoice)
        } else if width < -swipeThreshold {
            processChoice(choice: card.leftChoice)
        }
        
        offset = .zero
    }
    
    private func handleChoice(choice: String?) {
        guard let choice = choice else { return }
        
        if let nextCard = decisionTree[choice] {
            currentCard = nextCard
        } else if let infoPage = infoPages[choice] {
            currentInfoPage = infoPage
            withAnimation {
                viewState = .infoPage
            }
        }
    }
}

struct InfoPageView: View {
    let info: InfoPage
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: info.imageSymbol)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                Text(info.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(info.content)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
            }
            .padding()
        }
        .background(Color(.systemBackground))
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
            
            VStack(spacing: 20) {
                Text(card.content)
                    .font(.custom("Avenir-Medium", size: 24))
                    .foregroundColor(ThemeColors.text)
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack(spacing: 50) {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .foregroundColor(.gray)
                        .accessibilityLabel("Swipe Left")
                    
                    Image(systemName: "arrow.right")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                }
            }
        }
        .frame(width: 300, height: 400)
    }
}

struct LoadingView: View {
    @State private var animateLeaves = false
    @State private var animateBolt = false

    var body: some View {
        ZStack {
            
            ThemeColors.background
                .ignoresSafeArea()

           
            Image(systemName: "bolt.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(ThemeColors.accent)
                .opacity(animateBolt ? 1.0 : 0.3)
                .scaleEffect(animateBolt ? 1.1 : 0.9)
                .animation(
                    Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true),
                    value: animateBolt
                )
                .onAppear {
                    animateBolt.toggle()
                }

            // Falling Leaves Animation
            ZStack {
                ForEach(0..<10, id: \.self) { index in
                    LeafView()
                        .offset(x: CGFloat.random(in: -150...150), y: animateLeaves ? 600 : -600)
                        .rotationEffect(.degrees(animateLeaves ? Double.random(in: 0...360) : 0))
                        .scaleEffect(0.8)
                        .animation(
                            Animation.linear(duration: Double.random(in: 3...5))
                                .repeatForever(autoreverses: false),
                            value: animateLeaves
                        )
                }
            }
            .onAppear {
                animateLeaves.toggle()
            }
        }
    }
}

// A leaf view to represent a falling leaf
struct LeafView: View {
    var body: some View {
        Image(systemName: "leaf.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(ThemeColors.primary)
    }
}

// Data structures for carbon calculations
struct CarbonMetrics {
    var transportEmissions: Double = 0
    var energyEmissions: Double = 0
    var foodEmissions: Double = 0
    var wasteEmissions: Double = 0
    
    var totalEmissions: Double {
        transportEmissions + energyEmissions + foodEmissions + wasteEmissions
    }
}


struct CreditsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Group {
                        Text("Sources and Citations")
                            .font(.title)
                            .bold()
                        
                        CitationSection(
                            title: "Environmental Impact Data",
                            sources: [
                                "https://www.theatlantic.com/technology/archive/2024/09/microsoft-ai-oil-contracts/679804/?utm_source=chatgpt.com",
                                "https://apnews.com/article/ai-data-centers-ireland-6c0d63cbda3df740cd9bf2829ad62058",
                                "https://www.wired.com/story/true-cost-generative-ai-data-centers-energy/?utm_source=chatgpt.com",
                                "https://www.sustainabilitybynumbers.com/p/ai-energy-demand"
                            ]
                        )
                        
                        CitationSection(
                            title: "AI Efficiency Statistics",
                            sources: [
                                "https://www.cencepower.com/calculators/kwh-to-co2-calculator ",
                                "https://www.nature.com/articles/s41467-024-50088-4#:~:text=Adopting%20AI%20will%20help%20the,the%20policy%20scenario%20without%20AI.",
                                "https://www.captechu.edu/blog/moving-towards-more-sustainable-future-using-ai",
                                "https://www.reuters.com/sustainability/land-use-biodiversity/field-cloud-how-ai-is-helping-regenerative-agriculture-grow-2024-09-18/?utm_source=chatgpt.com", "https://coaxsoft.com/blog/using-ai-for-sustainability-case-studies-and-examples?utm_source=chatgpt.com", "https://www.thetimes.com/business-money/technology/article/saving-the-planet-one-ai-tool-at-a-time-mxgjfk8jh?utm_source=chatgpt.com&region=global"
                            ]
                        )
                        
                        CitationSection(
                            title: "Swift UI Skills",
                            sources: [
                                "https://www.appcoda.com/swiftui-animation-basics-building-a-loading-indicator/",
                                "https://dpatel1.medium.com/building-an-ai-chat-bot-on-ios-swiftui-c430814880b9",
                                "https://developer.apple.com/documentation/charts",
                                "https://stackoverflow.blog/2021/08/14/level-up-build-a-quiz-app-with-swiftui-part-1/"
                            ]
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Close") {
                isPresented = false
            })
        }
    }
}

// Helper view for citations
struct CitationSection: View {
    let title: String
    let sources: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            ForEach(sources, id: \.self) { source in
                Text("• \(source)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}


struct ContentView: View {
    @State private var showCredits = false
    @State private var viewState: ViewState = .loading
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color(ThemeColors.background)
                    .edgesIgnoringSafeArea(.all)
               
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            viewState = .loading
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(ThemeColors.primary)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showCredits = true
                        }) {
                            Text("Credits")
                                .foregroundColor(ThemeColors.primary)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 2)
                    Spacer()
                    
                    switch viewState {
                    case .loading:
                        LoadingView()
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        viewState = .cards
                                    }
                                }
                            }
                        
                        
                        
                    case .cards:
                        CardStack()
                        
                    case .infoPage:
                        EnvironmentalImpactPage()
                        
                    case .chatbot:
                        ChatbotView()
                        
                    default:
                        Text("Unhandled state")
                            .foregroundColor(.red)
                    }
                                        
                Spacer()
                    
                }
                
                    
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showCredits) {
                CreditsView(isPresented: $showCredits)
            }
        }
    }
}




#Preview {
    ContentView()
}
