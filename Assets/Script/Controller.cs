using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Controller : MonoBehaviour
{

    public float moveSpeed;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        /* 
        if(Input.GetKey(KeyCode.A)){
            transform.Translate(-moveSpeed * Time.deltaTime, 0 , 0);
        }
        if(Input.GetKey(KeyCode.D)){
            transform.Translate(moveSpeed * Time.deltaTime, 0 , 0);
        }
        if(Input.GetKey(KeyCode.W)){
            transform.Translate(0, moveSpeed * Time.deltaTime , 0);
        }
        if(Input.GetKey(KeyCode.S)){
            transform.Translate(0, -moveSpeed * Time.deltaTime , 0);
        }
        if(Input.GetKey(KeyCode.Space)){
            BubbleCreator.main.CreateBubbles();
        }
        */

        var v3 = Input.mousePosition;
        v3.z = -Camera.main.transform.position.z;
        v3 = Camera.main.ScreenToWorldPoint(v3);
        transform.position = v3;
    }
}
