//
// тестовый пример работы OpenCV и SOINN
// http://haselab.info/soinn-e.html
//
// http://robocraft.ru
//

#include <cv.h>
#include <highgui.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <iostream>
#include <sstream>

#include "CSOINN.h"

#define DIMENSION			2
#define REMOVE_NODE_TIME	200
#define DEAD_AGE			100

// показать информацию о SOINN-сети
void show_SOINN_info(CSOINN* pSOINN);

// цисло цветов
#define MAX_COLOR 16
// массив цветов
CvScalar m_color[MAX_COLOR];

// заполнить цветовой массив
void CreateColor();

// показать сеть SOINN на картинке :)
void show_SOINN(CSOINN* pSOINN, IplImage* img);

IplImage *soinn = 0;

CSOINN* pSOINN = 0;

// обработчик событий от мышки
void myMouseCallback( int event, int x, int y, int flags, void* param );

int main(int argc, char* argv[])
{
	// картинка для рисования 
	soinn = cvCreateImage(cvSize(400, 300), IPL_DEPTH_8U, 3);

	// очистим картинку
	cvZero(soinn);
 
	// окно для отображения сети
	cvNamedWindow("SOINN");

	// заполним массив цветов
	CreateColor();

	printf("[i] Start...\n");

	// создание объекта SOINN
	pSOINN = new CSOINN ( DIMENSION , REMOVE_NODE_TIME , DEAD_AGE );

	if(!pSOINN){
		printf("[!] Error: cant allocate memory!\n");
		return -1;
	}

	// вешаем обработчик мышки
    cvSetMouseCallback( "SOINN", myMouseCallback, (void*) soinn);

	while(cvWaitKey(33)!=27){

		cvShowImage("SOINN", soinn);

#if 0
		// сохранение в файл
		std::stringstream ss;
		ss<<"round_"<<round<<".jpg";
		cvSaveImage(ss.str().c_str(), soinn);
#endif
	}
	
	//-----------------------------------------

	if(pSOINN){
		delete pSOINN;
		pSOINN = 0;
	}

	// ждём нажатия клавиши
	//cvWaitKey(0);

	// освобождаем ресурсы
	cvReleaseImage(&soinn);
	// удаляем окна
	cvDestroyAllWindows();

	printf("[i] End.\n");
	return 0;
}

// показать информацию о SOINN-сети
void show_SOINN_info(CSOINN* pSOINN)
{
	if(!pSOINN){
		return;
	}

	// покажем информацию о сети
	printf("[ ] SOINN info: \n");
	printf("[i] Dimension: %d\n", pSOINN->GetDimension());
	printf("[i] NodeNum: %d\n", pSOINN->GetNodeNum());
	printf("[i] EdgeNum: %d\n", pSOINN->GetEdgeNum());
	printf("[i] ClassNum: %d\n", pSOINN->GetClassNum());
	printf("----------------------------\n");

}

// заполнить цветовой массив
void CreateColor()
{
	m_color[0] = CV_RGB(64+128, 64, 64);
	m_color[1] = CV_RGB(64, 64+128, 64);
	m_color[2] = CV_RGB(64, 64, 64+128);
	m_color[3] = CV_RGB(64+128, 64+128, 64);
	m_color[4] = CV_RGB(64+128, 64, 64+128);
	m_color[5] = CV_RGB(64, 64+128, 64+128);
	m_color[6] = CV_RGB(64, 64, 64);
	m_color[7] = CV_RGB(64, 64+64, 64+128);
	m_color[8] = CV_RGB(64+64, 64+128, 64);
	m_color[9] = CV_RGB(64+128, 64, 64+64);
	m_color[10] = CV_RGB(64, 64+128, 64+64);
	m_color[11] = CV_RGB(64+64, 64, 64+128);
	m_color[12] = CV_RGB(64+128, 64+64, 64);
	m_color[13] = CV_RGB(64+128, 64+64, 64+64);
	m_color[14] = CV_RGB(64+64, 64+128, 64+64);
	m_color[15] = CV_RGB(64+64, 64+64, 64+128);
}

// показать сеть SOINN на картинке :)
void show_SOINN(CSOINN* pSOINN, IplImage* img)
{
	if(!pSOINN || !img){
		return;
	}

	int i, f, t, nodeNum, edgeNum;
	double x, y, x0, y0, x1, y1;
	CNode* node;
	CEdge* edge;

	// очистим картинку
	cvZero(img);

	edgeNum = pSOINN->GetEdgeNum();
	for (i=0; i<edgeNum; i++){
		edge = pSOINN->GetEdge(i);
		f = edge->m_from;
		node = pSOINN->GetNode(f);
		x0 = node->m_signal[0];
		y0 = node->m_signal[1];

		t = edge->m_to;
		node = pSOINN->GetNode(t);
		x1 = node->m_signal[0];
		y1 = node->m_signal[1];

		cvLine(img, cvPoint((int)x0, (int)y0), cvPoint((int)x1, (int)y1), CV_RGB(250,250,250), 1, 8);
	}

	nodeNum = pSOINN->GetNodeNum();
	for (i=0; i<nodeNum; i++){
		node = pSOINN->GetNode(i);
		
		x = node->m_signal[0];
		y = node->m_signal[1];

		cvCircle(img,cvPoint((int)x, (int)y), 2, m_color[node->m_classID%MAX_COLOR], -1, 8);
	}
}

// обработчик событий от мышки
void myMouseCallback( int event, int x, int y, int flags, void* param )
{
		double signal[DIMENSION];

        switch( event ){
                case CV_EVENT_MOUSEMOVE: 
                        break;

                case CV_EVENT_LBUTTONDOWN:
                        printf("%d x %d\n", x, y);
                        
						if(pSOINN && soinn){
							signal[0] = x;
							signal[1] = y;
							// добавляем данные в сеть
							pSOINN -> InputSignal ( signal );

							// классификация данных
							pSOINN -> Classify ();

							// поcмотрим информацию о SOINN-сети
							show_SOINN_info(pSOINN);

							// нарисуем картинку
							show_SOINN(pSOINN, soinn);
						}
                        break;

                case CV_EVENT_LBUTTONUP:
                        break;
        }
}
