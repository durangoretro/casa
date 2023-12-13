#include <system.h>
#include <qgraph.h>
#include <psv.h>
#include "bin/title.h"
#include "bin/dibu01.h"


// method declarations
int main(void);
void displayTitle(void);

// Implementation

int main() {
    displayTitle();
    
    drawBackImg(dibu01);
    
    while(1) {
    }    
        
    return 0;
}


void displayTitle() {
    drawBackImg(title);
    waitStart();
}

