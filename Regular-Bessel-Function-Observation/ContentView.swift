//
//  ContentView.swift
//  Regular-Bessel-Function-Observation
//
//  Created by Jeff_Terry on 1/13/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var guess = ""
    @State private var totalInput: Int? = 18
    @State var besselResultArray :[(direction: String, xValue: Double, order: Int, start: Int, besselValue: Double)] = []
    
    private var intFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f
    }()
    
    var body: some View {
    
       VStack {
            HStack {
                
                TextEditor(text: $guess)

                
                Button("Calculate Bessel Functions", action: calculateBesselFunc)
                    }
            .frame(minHeight: 300, maxHeight: 800)
            .frame(minWidth: 480, maxWidth: 800)
            .padding()
        
        HStack{
            
            Text(verbatim: "Order:")
            .padding()
            TextField("Total", value: $totalInput, formatter: intFormatter)
        
                .padding()
            
            }
        }
        
    }

    
    func calculateBesselFunc()   {

    //let xmax = 16.0                     /* max of x  */
        let xmax = 0.7                     /* max of x  */
    let xmin = 0.1                     /* min of x >0  */
    let step = 0.1                      /* delta x  */
    let order = totalInput ?? 0                      /* order of Bessel function */
    let start = order+25                      /* used for downward algorithm */
    //var x = 0.0
    var maxIndex = 0
        
    let myResults = ActorArray()
        
    besselResultArray.removeAll()
        
    guess = String(format: "J%d(x)\n", order)
    maxIndex = Int(((xmax-xmin)/step))+1

    for index in (0...maxIndex)
    {
        
        calculateUpwardDownwardBessel(index: index, step: step, xmin: xmin, order: order, start: start, myResults: myResults)
        
       /*
        let resultsOfTaskCalculation = await withTaskGroup(of: (counter: Int, value: Double).self /* this is the return from the taskGroup*/,
            returning: [(counter: Int, value: Double)].self /* this is the return of all of the results */,
            body: { taskGroup in  /*This is the body of the task*/
            
            // We can use `taskGroup` to spawn child tasks here.
            
            taskGroup.addTask {
                
                //Create a new instance of the Calculator object so that each has it's own calculating function to avoid potential issues with reentrancy problem
                let downwardResult = await calculateUpwardDownwardBessel(index: index, step: step, xmin: xmin, order: order, start: start)
                
                
                return (downwardResult)  /* this is the return from the taskGroup*/
                
            }
            
                
            
            
            
            // Collate the results of all child tasks
            var combinedTaskResults :[(counter: Int, value: Double)] = []
            for await result in taskGroup {
                
                combinedTaskResults.append(result)
            }
            
            return combinedTaskResults  /* this is the return from the result collation */
            
        })
        
        //Do whatever processing that you need with the returned results of all of the child tasks here.
        
        // Sort the results based upon the direction of the result
        let sortedCombinedResults = resultsOfTaskCalculation.sorted(by: { $0.0 > $1.0 })
        
        
        
        await whateverneedsToBeUpdated(array: sortedCombinedResults)

        
    
        
    
         
      */
        
    }
        

    }
    
    func calculateUpwardDownwardBessel(index: Int, step: Double, xmin: Double, order: Int, start: Int, myResults: ActorArray)  {
        
        
        
        Task{
            
            
            let resultsOfTaskCalculation = await withTaskGroup(of: (direction: String, xValue: Double, order: Int, start: Int, besselValue: Double).self /* this is the return from the taskGroup*/,
                                                               returning: [(direction: String, xValue: Double, order: Int, start: Int, besselValue: Double)].self /* this is the return of all of the results */,
                                                               body: { taskGroup in  /*This is the body of the task*/
                
                // We can use `taskGroup` to spawn child tasks here.
                
                
                taskGroup.addTask {
                    
                    let x = Double(index)*step + xmin
                    
                    //Create a new instance of the Bessel Function Calculator object so that each has it's own calculating function to avoid potential issues with reentrancy problem
                    let downwardResult = await BesselFunctionCalculator().calculateDownwardRecursion(xValue: x, order: order, start: start)
                    
                    
                    return (downwardResult)  /* this is the return from the taskGroup*/
                    
                }
                taskGroup.addTask {
                    
                    let x = Double(index)*step + xmin
                    //Create a new instance of the Bessel Function Calculator object so that each has it's own calculating function to avoid potential issues with reentrancy problem
                    let upperResult = await BesselFunctionCalculator().calculateUpwardRecursion(xValue: x, order: order)
                    
                    return (upperResult)  /* this is the return from the taskGroup*/
                    
                }
                
                
                // Collate the results of all child tasks
                var combinedTaskResults :[(direction: String, xValue: Double, order: Int, start: Int, besselValue: Double)] = []
                for await result in taskGroup {
                    
                    combinedTaskResults.append(result)
                }
                
                return combinedTaskResults  /* this is the return from the result collation */
                
            })
            
            //Do whatever processing that you need with the returned results of all of the child tasks here.
            
            // Sort the results based upon the direction of the result
            let sortedCombinedResults = resultsOfTaskCalculation.sorted(by: { $0.0 > $1.0 })
            
            
            
//            var guessString = ""
//            
//            for item in sortedCombinedResults{
//                
//                // Display the sorted text in the GUI
//                //await updateGUI(text: "\(item.1)")
//                
//                guessString += String(format: "x = %f", item.xValue)
//                guessString += " "
//                guessString += item.direction
//                guessString += " "
//                guessString += String(format: "Bessel = %7.5e", item.besselValue)
//                guessString += "\n"
//                
//
//
//
 //           }
            
            let test = await myResults.appendArrays(arrayToAppend: sortedCombinedResults)
 //           await updateBesselArray(array: sortedCombinedResults)
 //           await updateGUI(text: guessString)
            
            
            await updateBesselArray(array: test)
            
            print(test.count, besselResultArray.count)
            
            
        }
        
        return
    }
    
    /// updateGUI
    /// This adds the text String to the text displayed in the GUI.
    /// This function runs on the Main Thread only
    /// - Parameter text: text to be added so that it can be displayed
    @MainActor func updateGUI(text:String){
        
        guess += text
        
    }
    
    @MainActor func updateBesselArray(array:[(direction: String, xValue: Double, order: Int, start: Int, besselValue: Double)]){
        
        besselResultArray += array
        
        print(besselResultArray)
        
    }


}

#Preview {
    ContentView()
}
