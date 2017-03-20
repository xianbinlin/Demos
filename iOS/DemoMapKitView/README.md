# Demo MapKitView with GKStateMachine in no game app

This demo shows how to use MapkitView in swift3, and I try to apply a state machine to this application. As we know,  the big problem in MVC architecture is the Controller contains lots of codes, the logic of application could be very complicated. Here I would like to bring a state machine into this demo, and see how much we could simplify the application's logic.

GKstateMachine is introduced in iOS9 as a part of GameplayKit which allows developers to manage a machine that combines several states. In this demo, we have 3 states: **StartState**, **PreviewState**, **NavigationState**. We will explain each state below.

----------------------------
## StartState

![alt text](https://github.com/xianbinlin/Demos/blob/master/iOS/DemoMapKitView/docs/start.PNG?raw=true
 "StartState")

 A StartState looks like this, it shows user's location and a search bar. it waits for users to search address. Once we have a destination address, we go to next state : **PreviewState**.

 **  Resume **

  \+ means show/true, \- means hide/false.
 - UI : + search bar , + user location.
 - NextState: PreviewState.

-------------------------------
## PreviewState

![alt text](https://github.com/xianbinlin/Demos/blob/master/iOS/DemoMapKitView/docs/preview.PNG?raw=true
 "PreviewState")

A PreviewState adds 2 buttons Go and Clean, when users click Go, we go to NavigationState, or users click Clean, we go back to StartState.

** Resume **
- UI: + search bar, + an annotation, + route, + GoButton, + CleanButton.
- NextState : StartState, NavigationState

---------------------------------------

## NavigationState

![alt text](https://github.com/xianbinlin/Demos/blob/master/iOS/DemoMapKitView/docs/navigation.PNG?raw=true
 "NavigationState")

 Until now, a state is clear for you, let's go to resume directly.

 ** Resume **

 - UI: - search bar, - GoButton, - CleanButton, + CancelButton, + ZoomInUserLocation, + route

------------------------------



 ## State machine

 ![alt text]( https://github.com/xianbinlin/Demos/blob/master/iOS/DemoMapKitView/docs/stateMachine.png?raw=true
  "NavigationState")

A **stateMachine** does :

- which is current state
- which is/are next possible states
- what are the conditions to go to next state

For example:

On StartState:
- users can only go to PreviewState by searching an address or tap long to add an address.

On PreviewState:
- users can go back to StartState by tapping CleanButton or clean the address in search bar.
- users can go to NavigationState by tapping GoButton.

On NavigationState:
- users can only go to StartState by tapping CancelButton.

I have created a class to build stateMachine, but you can create it directly in ViewController.

  public class StateMachineMagager: GKStateMachine {

      init(forViewController vc:ViewController) {
          super.init(states: [
              StartState(vc: vc),
              PreviewState(vc: vc),
              NavigationState(vc: vc)])
          enter(StartState.self)
      }
    }

Then when application touch the conditions to go to next state, just tell the state machine to go.

When we tap CleanButton: I have create an enum for states, but it's possible to give the class of state to state machine.

    @IBAction func tapClean(_ sender: UIButton) {
            enterNextState(state: StateCase.start.getSelf())
        }

when we clean the text in search bar:

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            vcDelegate?.enterNextState(state: StateCase.start.getSelf())
        }
    }



## GKState

A **state** presents what UI should we present to users when stateMachine is on one state.

Let's look an example of StartState.


    class StartState: GKState {
      weak var vc:ViewController?
      // 1
      init(vc:ViewController) {
          self.vc = vc
      }
      // 2
      override func isValidNextState(_ stateClass: AnyClass) -> Bool {
          return stateClass is PreviewState.Type
      }
      // 3
      override func didEnter(from previousState: GKState?) {
          // could evaluate UI state from previousState
          vc?.goButtonOutlet.isHidden = true
          vc?.cancelButtonOutlet.isHidden = true
          vc?.clearButtonOutlet.isHidden = true
          vc?.navigationController?.isNavigationBarHidden = false
          vc?.setSearchBarText(text: "")
          if let annotations = vc?.mapView.annotations{
              vc?.mapView.removeAnnotations(annotations)
          }

          if let routes = vc?.mapView.overlays{
              vc?.mapView.removeOverlays(routes)
          }

          vc?.mapView.showUserLocation()
      }

      override func willExit(to nextState: GKState) {
          // no need for this demo
      }

      override func update(deltaTime seconds: TimeInterval) {
          // no need for this demo
      }
    }


1. give a reference of ViewController to StartState, then StartState can update ViewController's UI when StartState is current state.

2. MachineState calls this function to know what are possible next states.

3. Do all UI job when we are this state. In this example,  


## What we benefit from this architecture ???

In this application, we have 3 parts: ViewController, UI and managers(Mapview Manager, search bar manager...all logic without UI).

1. Your ViewController is very small, it does only:
  - init objects
  - tell state machine to go next state
  -

2. code for updating UI are separated into a single file, for each state, how to present UI is clear.

3. The logic in managers is simple, we don't need to update UI in logic code, just tell state machine to go to one state.

4. it's easy to do unit test.

For more details, please look into source code.
