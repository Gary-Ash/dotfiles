FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ��****************************************************************************************
 * Document.documentWillSave.scpt
 *
 * Update my file heading comment
 *
 * Author   :  Gary Ash <gary.ash@icloud.com>
 * Created  :  10-Aug-2024. 7:56pm 
 * Modified :
 *
 * Copyright � 2024 By Gary Ash All rights reserved.
 ***************************************************************************************     � 	 	& * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
   *   D o c u m e n t . d o c u m e n t W i l l S a v e . s c p t 
   * 
   *   U p d a t e   m y   f i l e   h e a d i n g   c o m m e n t 
   * 
   *   A u t h o r       :     G a r y   A s h   < g a r y . a s h @ i c l o u d . c o m > 
   *   C r e a t e d     :     1 0 - A u g - 2 0 2 4 .   7 : 5 6 p m   
   *   M o d i f i e d   : 
   * 
   *   C o p y r i g h t   �   2 0 2 4   B y   G a r y   A s h   A l l   r i g h t s   r e s e r v e d . 
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *   
  
 l     ��������  ��  ��        x     �� ����  0 bbreditlibrary BBREditLibrary  4    �� 
�� 
scpt  m       �    B B E d i t L i b r a r y��        x    �� ����    2   ��
�� 
osax��        l     ��������  ��  ��        i    !    I      �� ���� $0 documentwillsave documentWillSave   ��  o      ���� 0 doc  ��  ��    n        I    �� ���� *0 updateheadercomment updateHeaderComment    ��   o    ���� 0 doc  ��  ��     f        ! " ! l     ��������  ��  ��   "  # $ # i   " % % & % I      �� '���� *0 updateheadercomment updateHeaderComment '  (�� ( o      ���� 0 td  ��  ��   & O    � ) * ) k   � + +  , - , r     . / . n     0 1 0 1   	 ��
�� 
Ofse 1 n    	 2 3 2 1    	��
�� 
pusl 3 l    4���� 4 n     5 6 5 m    ��
�� 
cwin 6 o    ���� 0 td  ��  ��   / o      ���� 0 saveloc   -  7 8 7 l    �� 9 :��   9 � �*****************************************************************************************
 	 	 * find the copyright statement
		 ****************************************************************************************    : � ; ;� * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
   	   	   *   f i n d   t h e   c o p y r i g h t   s t a t e m e n t 
 	 	   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 8  < = < r      > ? > l    @���� @ I   �� A B
�� .R*chFindnull���     ctxt A l 	   C���� C m     D D � E E � C o p y r i g h t   �   ( 2 0 [ 0 - 9 ] * - 2 0 [ 0 - 9 ] * | 2 0 [ 0 - 9 ] * ) \ s * B y \ s * ( . * ) \ s * A l l   r i g h t s   r e s e r v e d .��  ��   B �� F G
�� 
FnIn F l 
   H���� H l    I���� I o    ���� 0 td  ��  ��  ��  ��   G �� J K
�� 
SelM J l 
   L���� L m    ��
�� boovtrue��  ��   K �� M��
�� 
Opts M K     N N �� O P
�� 
SMod O m    ��
�� SModGrep P �� Q��
�� 
STop Q m    ��
�� boovtrue��  ��  ��  ��   ? o      ���� (0 copyrightstatement copyrightStatement =  R S R l  ! !��������  ��  ��   S  T U T Z   !� V W���� V =  ! & X Y X l  ! $ Z���� Z n   ! $ [ \ [ 1   " $��
�� 
Fnd? \ o   ! "���� (0 copyrightstatement copyrightStatement��  ��   Y m   $ %��
�� boovtrue W k   )� ] ]  ^ _ ^ r   ) . ` a ` 1   ) ,��
�� 
pusl a o      ���� (0 copyrightstatement copyrightStatement _  b c b l  / /��������  ��  ��   c  d e d I  / ?�� f g
�� .R*chFindnull���     ctxt f l 	 / 0 h���� h m   / 0 i i � j j ` C o p y r i g h t   �   ( 2 0 [ 0 - 9 ] * - 2 0 [ 0 - 9 ] * | 2 0 [ 0 - 9 ] * ) \ s * B y \ s *��  ��   g �� k l
�� 
FnIn k l 
 1 4 m���� m 1   1 4��
�� 
pusl��  ��   l �� n o
�� 
SelM n l 
 5 6 p���� p m   5 6��
�� boovtrue��  ��   o �� q��
�� 
Opts q K   7 ; r r �� s��
�� 
SMod s m   8 9��
�� SModGrep��  ��   e  t u t l  @ @��������  ��  ��   u  v w v r   @ I x y x l  @ G z���� z n   @ G { | { 1   C G��
�� 
ECol | 1   @ C��
�� 
pusl��  ��   y o      ���� .0 startorganizationname startOrganizationName w  } ~ } l  J J��������  ��  ��   ~   �  I  J Z�� � �
�� .R*chFindnull���     ctxt � l 	 J M ����� � m   J M � � � � � . \ s * A l l   r i g h t s   r e s e r v e d .��  ��   � �� � �
�� 
FnIn � l 
 N O ����� � o   N O���� (0 copyrightstatement copyrightStatement��  ��   � �� � �
�� 
SelM � l 
 P Q ����� � m   P Q��
�� boovtrue��  ��   � �� ���
�� 
Opts � K   R V � � �� ���
�� 
SMod � m   S T��
�� SModGrep��  ��   �  � � � l  [ [��������  ��  ��   �  � � � r   [ f � � � \   [ d � � � l  [ b ����� � n   [ b � � � 1   ^ b��
�� 
SCol � 1   [ ^��
�� 
pusl��  ��   � m   b c����  � o      ���� *0 endorganizationname endOrganizationName �  � � � r   g � � � � c   g � � � � l  g � ���� � n   g � � � � 7 t ��~ � �
�~ 
cha  � o   z |�}�} .0 startorganizationname startOrganizationName � o   } �|�| *0 endorganizationname endOrganizationName � n   g t � � � 4   j t�{ �
�{ 
clin � l  m s ��z�y � n   m s � � � 1   n r�x
�x 
SLin � o   m n�w�w (0 copyrightstatement copyrightStatement�z  �y   � l  g j ��v�u � n   g j � � � m   h j�t
�t 
cwin � o   g h�s�s 0 td  �v  �u  ��  �   � m   � ��r
�r 
TEXT � o      �q�q $0 organizationname organizationName �  � � � l  � ��p�o�n�p  �o  �n   �  � � � l  � ��m�l�k�m  �l  �k   �  ��j � Z   �� � ��i�h � =  � � � � � n  � � � � � I   � ��g ��f�g &0 checkorganization checkOrganization �  ��e � o   � ��d�d $0 organizationname organizationName�e  �f   � o   � ��c�c  0 bbreditlibrary BBREditLibrary � m   � ��b
�b boovtrue � k   �� � �  � � � I  � ��a � �
�a .R*chFindnull���     ctxt � l 	 � � ��`�_ � m   � � � � � � �  C o p y r i g h t   � \ s *�`  �_   � �^ � �
�^ 
FnIn � l 
 � � ��]�\ � o   � ��[�[ (0 copyrightstatement copyrightStatement�]  �\   � �Z � �
�Z 
SelM � l 
 � � ��Y�X � m   � ��W
�W boovtrue�Y  �X   � �V ��U
�V 
Opts � K   � � � � �T ��S
�T 
SMod � m   � ��R
�R SModGrep�S  �U   �  � � � l  � ��Q�P�O�Q  �P  �O   �  � � � r   � � � � � l  � � ��N�M � n   � � � � � 1   � ��L
�L 
ECol � 1   � ��K
�K 
pusl�N  �M   � o      �J�J 0 	yearstart 	yearStart �  � � � r   � � � � � c   � � � � � l  � � ��I�H � n   � � � � � 7 � ��G � �
�G 
cha  � o   � ��F�F 0 	yearstart 	yearStart � l  � � ��E�D � [   � � � � � o   � ��C�C 0 	yearstart 	yearStart � m   � ��B�B �E  �D   � n   � � � � � 4   � ��A �
�A 
clin � l  � � ��@�? � n   � � � � � 1   � ��>
�> 
SLin � o   � ��=�= (0 copyrightstatement copyrightStatement�@  �?   � l  � � ��<�; � n   � � � � � m   � ��:
�: 
cwin � o   � ��9�9 0 td  �<  �;  �I  �H   � m   � ��8
�8 
TEXT � o      �7�7 &0 yearfromcopyright yearFromCopyright �  � � � l  � ��6�5�4�6  �5  �4   �  � � � Z   �8 � ��3�2 � ?   � � � � � l  � � ��1�0 � c   � � � � � n   � � � � � 1   � ��/
�/ 
year � l  � � ��.�- � I  � ��,�+�*
�, .misccurdldt    ��� null�+  �*  �.  �-   � m   � ��)
�) 
TEXT�1  �0   � o   � ��(�( &0 yearfromcopyright yearFromCopyright � Q   �4 � ��' � k   �+ � �  � � � r   � �  � l  ��&�% b   � b   �	 b   � b   � �	 b   � �

 b   � � m   � � �  C o p y r i g h t   �   o   � ��$�$ &0 yearfromcopyright yearFromCopyright m   � � �  -	 l  � ��#�" c   � � n   � � 1   � ��!
�! 
year l  � �� � I  � ����
� .misccurdldt    ��� null�  �  �   �   m   � ��
� 
TEXT�#  �"   m   � �    B y   l �� c   o  �� $0 organizationname organizationName m  �
� 
TEXT�  �   m  	 � *   A l l   r i g h t s   r e s e r v e d .�&  �%    o      �� $0 updatedstatement updatedStatement �   r  !"! o  �� $0 updatedstatement updatedStatement" l     #��# n      $%$ 1  �
� 
pcnt% o  �� (0 copyrightstatement copyrightStatement�  �    &'& r  %()( [  *+* l ,��, n  -.- 1  �
� 
ECol. o  �� (0 copyrightstatement copyrightStatement�  �  + m  �� ) l     /��
/ n      010 1   $�	
�	 
ECol1 o   �� (0 copyrightstatement copyrightStatement�  �
  ' 2�2 r  &+343 o  &'�� (0 copyrightstatement copyrightStatement4 1  '*�
� 
pusl�   � R      ���
� .ascrerr ****      � ****�  �  �'  �3  �2   � 565 l 99�� ���  �   ��  6 787 r  9M9:9 l 9K;����; I 9K��<=
�� .R*chFindnull���     ctxt< l 	9<>����> m  9<?? �@@ 0 ( M o d i f i e d | U p d a t e d ) \ s * : . *��  ��  = ��AB
�� 
FnInA l 
=>C����C o  =>���� 0 td  ��  ��  B ��DE
�� 
SelMD l 
?@F����F m  ?@��
�� boovtrue��  ��  E ��G��
�� 
OptsG K  AGHH ��IJ
�� 
SModI m  BC��
�� SModGrepJ ��K��
�� 
STopK m  DE��
�� boovtrue��  ��  ��  ��  : o      ���� 0 modifieddate modifiedDate8 LML l NN��������  ��  ��  M N��N Z  N�OP����O = NSQRQ l NQS����S n  NQTUT 1  OQ��
�� 
Fnd?U o  NO���� 0 modifieddate modifiedDate��  ��  R m  QR��
�� boovtrueP k  V�VV WXW r  V[YZY 1  VY��
�� 
puslZ o      ���� .0 modifieddateselection modifiedDateSelectionX [\[ l \\��������  ��  ��  \ ]^] I \l��_`
�� .R*chFindnull���     ctxt_ l 	\_a����a m  \_bb �cc  : . * $��  ��  ` ��de
�� 
FnInd l 
`af����f o  `a���� .0 modifieddateselection modifiedDateSelection��  ��  e ��gh
�� 
SelMg l 
bci����i m  bc��
�� boovtrue��  ��  h ��j��
�� 
Optsj K  dhkk ��l��
�� 
SModl m  ef��
�� SModGrep��  ��  ^ mnm l mm��������  ��  ��  n opo I mt��q��
�� .coredelonull���     obj q 1  mp��
�� 
pusl��  p rsr l uu��������  ��  ��  s tut r  u�vwv n u�xyx I  z���z���� *0 formatdatetimestamp formatDateTimeStampz {��{ l z|����| I z������
�� .misccurdldt    ��� null��  ��  ��  ��  ��  ��  y o  uz����  0 bbreditlibrary BBREditLibraryw o      ���� 	0 stamp  u }��} r  ��~~ l �������� c  ����� l �������� b  ����� m  ���� ���  :    � o  ������ 	0 stamp  ��  ��  � m  ����
�� 
TEXT��  ��   1  ����
�� 
pusl��  ��  ��  ��  �i  �h  �j  ��  ��   U ���� I �������
�� .miscslctnull��� ��� obj � n  ����� n  ����� 9  ����
�� 
cins� 4  �����
�� 
cha � o  ������ 0 saveloc  � o  ������ 0 td  ��  ��   * m     ���                                                                                  R*ch  alis    "  Macintosh HD               �<u�BD ����
BBEdit.app                                                     ������        ����  
 cu             Applications  /:Applications:BBEdit.app/   
 B B E d i t . a p p    M a c i n t o s h   H D  Applications/BBEdit.app   / ��   $ ���� l     ��������  ��  ��  ��       ���������  � ��������
�� 
pimr��  0 bbreditlibrary BBREditLibrary�� $0 documentwillsave documentWillSave�� *0 updateheadercomment updateHeaderComment� ����� �  ��� �����
�� 
cobj� ��   �� 
�� 
scpt��  � �����
�� 
cobj� ��   ��
�� 
osax��  � ��   �� 
�� 
scpt� �� ���������� $0 documentwillsave documentWillSave�� ����� �  ���� 0 doc  ��  � ���� 0 doc  � ���� *0 updateheadercomment updateHeaderComment�� )�k+  � �� &���������� *0 updateheadercomment updateHeaderComment�� ����� �  ���� 0 td  ��  � ��������������������~�}�� 0 td  �� 0 saveloc  �� (0 copyrightstatement copyrightStatement�� .0 startorganizationname startOrganizationName�� *0 endorganizationname endOrganizationName�� $0 organizationname organizationName�� 0 	yearstart 	yearStart�� &0 yearfromcopyright yearFromCopyright�� $0 updatedstatement updatedStatement� 0 modifieddate modifiedDate�~ .0 modifieddateselection modifiedDateSelection�} 	0 stamp  � )��|�{�z D�y�x�w�v�u�t�s�r�q�p i�o ��n�m�l�k�j�i ��h�g�f�e�d?b�c�b��a�`
�| 
cwin
�{ 
pusl
�z 
Ofse
�y 
FnIn
�x 
SelM
�w 
Opts
�v 
SMod
�u SModGrep
�t 
STop�s �r 
�q .R*chFindnull���     ctxt
�p 
Fnd?
�o 
ECol
�n 
SCol
�m 
clin
�l 
SLin
�k 
cha 
�j 
TEXT�i &0 checkorganization checkOrganization
�h .misccurdldt    ��� null
�g 
year
�f 
pcnt�e  �d  
�c .coredelonull���     obj �b *0 formatdatetimestamp formatDateTimeStamp
�a 
cins
�` .miscslctnull��� ��� obj �������,�,�,E�O���e����e�� E�O��,e w*�,E�O��*�,�e���l� O*�,a ,E�Oa ��e���l� O*�,a ,kE�O��,a �a ,E/[a \[Z�\Z�2a &E�Ob  �k+ e a ��e���l� O*�,a ,E�O��,a �a ,E/[a \[Z�\Z�m2a &E�O*j a ,a &� T Ha �%a %*j a ,a &%a %�a &%a %E�O��a ,FO�a ,��a ,FO�*�,FW X   !hY hOa "��e����e�� E�O��,e  B*�,E�Oa #��e���l� O*�,j $Ob  *j k+ %E�Oa &�%a &*�,FY hY hY hO�a �/a '4j (Uascr  ��ޭ