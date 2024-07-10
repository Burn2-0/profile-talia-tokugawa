/*-------------------------------------------------------------*/
/*
            Talia's Firestorm PointAt Info Giver.

Make sure that the debug settings:
  - FSParticleChat is TRUE
  - PrivatePointAtTarget is FALSE
  
Click to turn on and off, Hold click for {TT} sec to switch mode:
  - OwnerSay
  - RegionSayTo
  - RegionSay on channel {DB_CHAN}
  - OwnerSay w/ SetText
  - RegionSayTo  w/ SetText
  - RegionSay on channel {DB_CHAN} w/ SetText
  - SetText                                                    */
/*-------------------------------------------------------------*/
/*   Talia's Firestorm PointAt Info Giver © 2024               */
/*  By Talia Tokugawa is licensed under CC BY-NC-SA 4.0        */
/*-------------------------------------------------------------*/

/* -------------------- Constants ---------------------------- */
// Hold/Click Timeout
#define TT 2 

// Number of Modes
#define M llGetListLength(MODES)

// Listen Channel
#define LC 9000

// Debug Channel 
// (I as standard have a specific channel I feed all debug text to 
// so I am able to switch it all off with the one device that passes it from that channel to me.)
#define DB_CHAN -9999

// Colours
#define MODES [<0.5,0,0>,<0,0.5,0>,<0,0,0.5>,<0.9,0.5,0>,<0,0.9,0.5>,<0.5,0,0.9>,<0.9,0.5,0.5>]
#define CLICK_ON <0.7,0.7,0.7>
#define HOLD_ON <0.3,0.3,0.3>
#define BASE <0.5,0.5,0.5>

// Alphas
#define PRIM_ALPHA 0.5
#define TEXT_ALPHA 0.8

/* -------------------- Variables ---------------------------- */
integer On = TRUE;     // on/off toggle
integer lh;            // listen Handle
integer mode=0;        // mode
integer t=FALSE;       // toggle for hold vs click
vector cl;             // current colour

/* -------------------- Functions ---------------------------- */
// Given integer mode returns vector colour 
vector mc() { return llList2Vector(MODES,mode); }    
// Given Vector Color sets cl and prim colour to Color
col(vector v) { cl = v; llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_COLOR, ALL_SIDES,v,PRIM_ALPHA]); }
// 
set() { if (On) { cl = mc(); lh = llListen(LC, "", "", "");}
    else { cl = BASE; llListenRemove(lh); }
    col(cl);
}

/* -------------------- Main --------------------------------- */
default {
    state_entry() { set(); }
    on_rez(integer isp) { llResetScript(); }
    touch_start(integer itp) { t=FALSE; llResetTime(); col(CLICK_ON); }
    touch(integer itp) {if (llGetTime()>=TT && !t) {t=TRUE; col(HOLD_ON);} }
    touch_end(integer itp) { t=FALSE;
        if (llGetTime()>=TT) { ++mode; if (mode>=M) mode=0;}            
        else { On=!On; }
        set();
    }
    listen(integer ilc, string sna, key kid, string sme) {
        if (ilc==LC) {
            if (mode==0||mode==3) llOwnerSay(sme);
            else if (mode==1||mode==4) llRegionSayTo(llGetOwner(), 0, sme);
            else if (mode==2||mode==5) llRegionSay(DB_CHAN ,sme);
            if (mode>=3) llSetText(sme,mc(),TEXT_ALPHA);
            else llSetText("",BASE,0.);            
        }               
    }
}
