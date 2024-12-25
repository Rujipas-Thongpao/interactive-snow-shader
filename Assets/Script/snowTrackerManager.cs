using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class snowTrackerManager : MonoBehaviour
{
    [SerializeField] private Transform tracker;
    static int trackerPositionId = Shader.PropertyToID("_TrackerPosition"),
                trackerPositionsId = Shader.PropertyToID("_TrackerPositions"),
                trackerLengthId = Shader.PropertyToID("_TrackerLength");
    private Queue<Vector3> trackerQueue = new Queue<Vector3>();

    [SerializeField] Material mat;
    [SerializeField] private int trackerLength;

    void Start()
    {
        mat.SetInt(trackerLengthId, trackerLength);
        StartCoroutine(SampleTrackerPosition());
    }

    IEnumerator SampleTrackerPosition()
    {
        WaitForSeconds wait = new WaitForSeconds(1 / 10f);
        while (tracker != null)
        {
            // sample location
            if (trackerQueue.Count == trackerLength)
            {
                trackerQueue.Dequeue();
            }
            trackerQueue.Enqueue(tracker.position);

            mat.SetVector(trackerPositionId, tracker.position);
            //send to gpu
            List<Vector4> trackerPositions = new List<Vector4>();
            if (trackerQueue.Count > 0)
            {
                var trackerPositionsArray = trackerQueue.ToArray();
                for (int i = 0; i < trackerLength; i++)
                {
                    Vector4 pos = Vector4.zero;

                    if (i < trackerPositionsArray.Length)
                    {
                        Vector3 each = trackerPositionsArray[i];
                        pos = new Vector4(each.x, each.y, each.z, 0);
                    }
                    trackerPositions.Add(pos);
                }
                mat.SetVectorArray(trackerPositionsId, trackerPositions);
            }
            yield return wait;
        }
        yield return null;
    }


}
