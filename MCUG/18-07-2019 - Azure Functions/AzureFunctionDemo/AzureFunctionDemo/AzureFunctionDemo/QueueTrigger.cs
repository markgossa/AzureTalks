using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;

namespace FunctionApp1.Functions
{
    public static class QueueTrigger
    {
        [FunctionName("QueueTrigger")]
        public static void Run([QueueTrigger("queue-in", Connection = "")]string myQueueItem,
            [Queue("queue-out", Connection = "")] out string outputQueue,
            ILogger log)
        {
            log.LogInformation($"C# Queue trigger function processed: {myQueueItem}");

            dynamic data = JsonConvert.DeserializeObject(myQueueItem);
            string name = data?.name ?? "Anonymous";

            outputQueue = $"Hello {name}!";
        }
    }
}
