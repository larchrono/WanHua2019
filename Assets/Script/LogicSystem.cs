using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LogicSystem : MonoBehaviour
{
    public static LogicSystem current;

    public GameObject [] ModelObjs;

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(InitModelObjs());
    }

    IEnumerator InitModelObjs()
    {
        yield return new WaitForSeconds(2.0f);
        for(int i = 0; i < 5; i++)
        {
            ModelObjs[i].SetActive(false);
        }
        //ResetPatternPosition();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
