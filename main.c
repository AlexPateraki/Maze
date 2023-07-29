#include <stdio.h>
#include <stdlib.h>
void printLabyrinth (void);
int makeMove(int index);
int movePlayer(int idx);
int W = 21;//width
int H = 11;//height
int startX = 1;//start of the labyrinth
int TotalElements = 231;//total elements of the array

char map[232] = "I.IIIIIIIIIIIIIIIIIII"//ASM: array
                "I....I....I.......I.I"
                "III.IIIII.I.I.III.I.I"
                "I.I.....I..I..I.....I"
                "I.I.III.II...II.I.III"
                "I...I...III.I...I...I"
                "IIIII.IIIII.III.III.I"
                "I.............I.I...I"
                "IIIIIIIIIIIIIII.I.III"
                "@...............I..II"
                "IIIIIIIIIIIIIIIIIIIII";

char temp[100]; //Global
int PlayerPos;
void printLabyrinth (void){
int i,j,k=0;
usleep(200000);
printf("Labyrinth:\n");//ASM: msg1
    for (i=0; i<H; i++){//ASM: label1
        for(j=0; j<W; j++){//ASM: label2
        if(k==PlayerPos)//ASM: label3
                temp[j]='P';
        else
        temp[j]=map[k];
        k++;
        }
    temp[j+1]='\0';
    printf("%s\n", temp);
    }

}

//=======ANADROMIKH======================================
/*int movePlayer(int idx){
    char button='\0';
            PlayerPos=idx;
            printLabyrinth();
    if(idx<0 || idx>=TotalElements){//label4
            return 0;
            }
        if(map[idx]=='.'){
            printf("Make your move:");//ASM: msg2
            scanf("%s",&button);
            if(button== 'D'){
                //map[idx]='*';
                return movePlayer(idx +1);
            }
            else if(button=='S'){
                //map[idx]='*';
                return movePlayer(idx +W);
            }
            else if(button=='A'){
                //map[idx]='*';
                return movePlayer(idx -1);
            }
            else if(button=='W'){
                //map[idx]='*';
                return  movePlayer(idx -W);
            }
            else if(button=='E'){
                makeMove(startX);
                return 0;
            }
            else {
                printf("Invalid choice.Game over...\n");//ASM: msg3
                return 0;
            }
        }else if (map[PlayerPos]=='@'){
                printf("Winner Winner Chicken Dinner!!!\n");//ASM: msg4
                return 0;
        }
        else {
                printf("You hit the wall.Game over...");//ASM: msg5
                return 0;
        }
return 0;
}*/
//=========================================================

//===================MH ANADROMIKH==============================
int movePlayer(int idx){
    char button='\0';
    PlayerPos=idx;
    printLabyrinth();

    if(idx<0 || idx>=TotalElements){
        return 0;
            }

while (map[PlayerPos]=='.'){
            printf("Make your move:");
            scanf("%s",&button);

            if(button== 'D'){
                PlayerPos=PlayerPos+1;
            }
            else if(button=='S'){
                PlayerPos=PlayerPos+W;
            }
            else if(button=='A'){
                PlayerPos=PlayerPos-1;
            }
            else if(button=='W'){
                PlayerPos=PlayerPos-W;

            }
            else if(button=='E'){
                makeMove(startX);
            }
            else
                {
                printf("Invalid choice.Game over...\n");//ASM: msg3
                return 0;
            }
            if (map[PlayerPos]!='I')
                printLabyrinth();
        }

        if (map[PlayerPos]=='@'){
            printf("Winner Winner Chicken Dinner!!!\n");//ASM: msg4
            return 0;
            }
        else if(map[PlayerPos]=='I'){
            printf("You hit the wall.Game over...\n");//ASM: msg5
            return 0;
            }

return idx;

}
//==================================================================

int makeMove(int index){
if(index<0 || index>=TotalElements)return 0;
if(map[index]=='.'){
    map[index]='*';
    printLabyrinth();
    if(makeMove(index+1)==1){//right
        map[index]='#';
        return 1;
    }
    if(makeMove(index+W)==1){//down
        map[index]='#';
        return 1;
    }
    if(makeMove(index-1)==1){//left
        map[index]='#';
        return 1;
    }
    if(makeMove(index-W)==1){//up
        map[index]='#';
    return 1;
    }
}else if (map[index]=='@'){
    map[index]='%';
    printLabyrinth();
    return 1;
}

return 0;
}


int main(void){
    movePlayer(startX);
return 0;
}
