public class FlowCall {
    public static void Flow() {
        // Prepare the Flow variables
        Map<String, String> params = new Map<String, String>();
        params.put('JobId', 'Successful');

        
        // Instantiate and start the Flow
        Flow.Interview.CallFlowFromApex yourFlow = new Flow.Interview.CallFlowFromApex(params);
        yourFlow.start();
    }
}