using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BubbleCreator : MonoBehaviour
{
    public static BubbleCreator main;

    public GameObject item;
    public GameObject soundItem;

    public float distance = 7;
    public int maxRow;
    public int maxCol;
    public int maxZ;

    public float randomSize_min = 2;
    public float randomSize_max = 5;

    public int soundRow;
    public int soundCol;
    public float soundDistance;

    Vector3 position;

    void Awake(){
        main = this;
    }
    // Start is called before the first frame update
    void Start()
    {
        CreateBubbles();
    }

    public void CreateBubbles(){
        for (int i = 0; i < maxRow; i++)
        {
            for (int j = 0; j < maxCol; j++)
            {
                for (int k = 0; k < maxZ; k++)
                {
                    float size = Random.Range(randomSize_min, randomSize_max);
                    item.transform.localScale = new Vector3(size, size, size);
                    float _x = -(maxCol * distance)/2;
                    float _y = -(maxRow * distance)/2;
                    GameObject obj = Instantiate(item, new Vector3(_x + j * distance,
                                                                   _y + i * distance,
                                                                    k * distance), Quaternion.identity);
                    
                    

                }

            }
        }

        for (int i = 0; i < soundRow; i++)
        {
            for (int j = 0; j < soundCol; j++)
            {
                float _x = -(soundCol * soundDistance)/2;
                float _y = -(soundRow * soundDistance)/2;
                GameObject sOnj = Instantiate(soundItem,new Vector3(_x + j * soundDistance,
                                                                   _y + i * soundDistance,
                                                                    0), Quaternion.identity);
            }
        }
    }
}
