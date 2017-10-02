#include "CVectorGeneratorFromFile.h"
#include <math.h>

const int CVectorGeneratorFromFile::ALL_CLASS = -1;

CVectorGeneratorFromFile::CVectorGeneratorFromFile() : CVectorGenerator()
{
	m_loaded = false;
	m_transrateMatrix[0] = NULL;
	m_transrateMatrix[1] = NULL;
	m_classData = NULL;
	m_generateClassNum = 0;
}

double* CVectorGeneratorFromFile::GenerateVector(void)
{
	int i, r;
	int targetClass, targetData;
	
	if (!m_loaded) return NULL;
	if (m_generateClassNum == 0) return NULL;

	targetClass = m_generateClass[rand()%m_generateClassNum];
	r = 0;
	for (i=0; i<(m_classData[targetClass].size/RAND_MAX)+1; i++)
	{
		r += rand();
	}
	targetData = r%m_classData[targetClass].size;
	for (i=0; i<m_dimension; i++)
	{
		m_signal[i] = m_classData[targetClass].data[targetData][i];
	}
	return m_signal;
}

bool CVectorGeneratorFromFile::GetDrawCoordinates(const double *signal, double &x, double &y)
{
	int i;
	
	x = 0.0;
	y = 0.0;
	
	if (!m_loaded) return false;
	if (signal == NULL) return false;
	
	for (i=0; i<m_dimension; i++)
	{
		x += m_transrateMatrix[0][i]*signal[i];
		y += m_transrateMatrix[1][i]*signal[i];
	}
	
	return true;
}

bool CVectorGeneratorFromFile::ReadVectorFile(const char *fileName)
{
	char fileType[4];
	HANDLE hFile;
	DWORD dwReadSize;
	int i, j;
	int nameLength;
	
	if (m_loaded) Clear();
	
	hFile = CreateFile(fileName, GENERIC_READ, FILE_SHARE_READ, NULL,  OPEN_EXISTING, 0, NULL);
	if (hFile == INVALID_HANDLE_VALUE) return false;
	ZeroMemory(fileType, sizeof(fileType));
	ReadFile(hFile, fileType, sizeof(char)*3, &dwReadSize, NULL);
	if (strcmp(fileType, "VCT") != 0)
	{
		CloseHandle(hFile);
		return false;
	}
	ReadFile(hFile, &m_dimension, sizeof(int), &dwReadSize, NULL);
	m_signal = new double[m_dimension];
	m_transrateMatrix[0] = new double[m_dimension];
	m_transrateMatrix[1] = new double[m_dimension];
	ReadFile(hFile, m_transrateMatrix[0], sizeof(double)*m_dimension, &dwReadSize, NULL);
	ReadFile(hFile, m_transrateMatrix[1], sizeof(double)*m_dimension, &dwReadSize, NULL);
	ReadFile(hFile, &m_classNum, sizeof(int), &dwReadSize, NULL);
	m_classData = new struct sClassData[m_classNum];
	for (i=0; i<m_classNum; i++)
	{
		ReadFile(hFile, &nameLength, sizeof(int), &dwReadSize, NULL);
		m_classData[i].name = new char[nameLength+1];
		ZeroMemory(m_classData[i].name, sizeof(char)*(nameLength+1));
		ReadFile(hFile, m_classData[i].name, sizeof(char)*nameLength, &dwReadSize, NULL);
		ReadFile(hFile, &m_classData[i].size, sizeof(int), &dwReadSize, NULL);
		m_classData[i].data = new double*[m_classData[i].size];
		for (j=0; j<m_classData[i].size; j++)
		{
			m_classData[i].data[j] = new double[m_dimension];
			ReadFile(hFile, m_classData[i].data[j], sizeof(double)*m_dimension, &dwReadSize, NULL);
		}
		m_classData[i].generate = true;
	}
	m_generateClassNum = m_classNum;
	m_generateClass = new int[m_generateClassNum];
	for (i=0; i<m_generateClassNum; i++)
	{
		m_generateClass[i] = i;
	}
	CloseHandle(hFile);
	m_loaded = true;

	return true;
}

bool CVectorGeneratorFromFile::Clear(void)
{
	int i, j;
	
	if (m_loaded == false) return false;
	
	m_loaded = false;
	m_dimension = 0;
	if (m_transrateMatrix[0] != NULL)
	{
		delete [] m_transrateMatrix[0];
		m_transrateMatrix[0] = NULL;
	}
	if (m_transrateMatrix[1] != NULL)
	{
		delete [] m_transrateMatrix[1];
		m_transrateMatrix[1] = NULL;
	}
	if (m_classData != NULL)
	{
		for (i=0; i<m_classNum; i++)
		{
			for (j=0; j<m_classData[i].size; j++)
			{
				delete [] m_classData[i].data[j];
			}
			delete [] m_classData[i].data;
			delete [] m_classData[i].name;
		}
		delete [] m_classData;
		m_classData = NULL;
	}
	m_classNum = 0;
	delete [] m_signal;
	m_signal = NULL;
	delete [] m_generateClass;
	m_generateClassNum = 0;

	return true;
}

char* CVectorGeneratorFromFile::GetClassName(const int targetClass)
{
	if (!m_loaded) return NULL;
	if (targetClass < 0 || m_classNum <= targetClass) return NULL;
	
	return m_classData[targetClass].name;
}

int CVectorGeneratorFromFile::GetClassSize(const int targetClass)
{
	if (!m_loaded) return 0;
	if (targetClass < 0 || m_classNum <= targetClass) return NULL;
	
	return m_classData[targetClass].size;
}

double* CVectorGeneratorFromFile::GetClassData(const int targetClass, const int targetData)
{
	if (!m_loaded) return NULL;
	if (targetClass < 0 || m_classNum <= targetClass) return NULL;
	if (targetData < 0 || m_classData[targetClass].size <= targetData) return NULL;
	
	return m_classData[targetClass].data[targetData];
}

int CVectorGeneratorFromFile::GetClassID(const double *signal)
{
	int i, j, classIDOfNearestData;
	double dist, minDist;

	minDist = 1e10;
	for (i=0; i<m_classNum; i++)
	{
		for (j=0; j<m_classData[i].size; j++)
		{
			dist = Distance(m_classData[i].data[j], signal);
			if (dist < minDist)
			{
				minDist = dist;
				classIDOfNearestData = i;
			}
		}
	}

	return classIDOfNearestData;
}

bool CVectorGeneratorFromFile::SetGenerateState(const int targetClass, const bool generate/*=true*/)
{
	int i;

	if (!m_loaded) return false;

	if (targetClass == ALL_CLASS)
	{
		for (i=0; i<m_classNum; i++)
		{
			m_classData[i].generate = generate;
		}
		if (generate)
		{
			m_generateClassNum = m_classNum;
			for (i=0; i<m_classNum; i++)
			{
				m_generateClass[i] = i;
			}
		}
		else
		{
			m_generateClassNum = 0;
		}
		return true;
	}
	else
	{
		if (targetClass < 0 || m_classNum <= targetClass) return false;
		if (m_classData[targetClass].generate == generate) return false;

		m_classData[targetClass].generate = generate;
		if (generate)
		{
			m_generateClass[m_generateClassNum] = targetClass;
			m_generateClassNum++;
		}
		else
		{
			m_generateClassNum--;
			for (i=0; i<m_generateClassNum; i++)
			{
				if (m_generateClass[i] == targetClass)
				{
					m_generateClass[i] = m_generateClass[m_generateClassNum];
				}
			}
		}

		return true;
	}
}

double CVectorGeneratorFromFile::Distance(const double *signal1, const double *signal2)
{
	int i;
	double dist;

	if (signal1 == NULL || signal2 == NULL) return 0.0;

	dist = 0.0;
	for (i=0; i<m_dimension; i++)
	{
		dist += (signal1[i]-signal2[i])*(signal1[i]-signal2[i]);
	}
	dist = sqrt(dist);

	return dist;
}
