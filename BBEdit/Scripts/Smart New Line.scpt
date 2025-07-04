FasdUAS 1.101.10   ��   ��    k             l      ��  ��   $
    Author: Kendall Conrad of Angelwatt.com
    Name: Smart Prefixed Newline
    Created: 2016-01-22
    Updated: 2016-01-22
    Description: Starts new line with the same line prefix as the current line and keeps the text
      from the current cursor position to the end of the line
     � 	 	< 
         A u t h o r :   K e n d a l l   C o n r a d   o f   A n g e l w a t t . c o m 
         N a m e :   S m a r t   P r e f i x e d   N e w l i n e 
         C r e a t e d :   2 0 1 6 - 0 1 - 2 2 
         U p d a t e d :   2 0 1 6 - 0 1 - 2 2 
         D e s c r i p t i o n :   S t a r t s   n e w   l i n e   w i t h   t h e   s a m e   l i n e   p r e f i x   a s   t h e   c u r r e n t   l i n e   a n d   k e e p s   t h e   t e x t 
             f r o m   t h e   c u r r e n t   c u r s o r   p o s i t i o n   t o   t h e   e n d   o f   t h e   l i n e 
   
  
 l   $ ����  O   $    O   #    k   "       I   ������
�� .miscactvnull��� ��� obj ��  ��        r        n        1    ��
�� 
SLin  1    ��
�� 
pusl  o      ���� 0 linenum lineNum      r    !    n        1    ��
�� 
leng  4    ��  
�� 
clin   o    ���� 0 linenum lineNum  o      ���� 0 leng     ! " ! l  " "�� # $��   #   Find leading whitespace    $ � % % 0   F i n d   l e a d i n g   w h i t e s p a c e "  & ' & r   " 5 ( ) ( I  " 1�� * +
�� .R*chFindnull���     ctxt * m   " # , , � - -  ( ^ [ \ s ] * ) + �� . /
�� 
Opts . K   $ ( 0 0 �� 1��
�� 
SMod 1 m   % &��
�� SModGrep��   / �� 2��
�� 
FnIn 2 4   ) -�� 3
�� 
clin 3 l  + , 4���� 4 o   + ,���� 0 linenum lineNum��  ��  ��   ) o      ���� 0 	theresult 	theResult '  5 6 5 l  6 6�� 7 8��   7 ( " Set text to the white space found    8 � 9 9 D   S e t   t e x t   t o   t h e   w h i t e   s p a c e   f o u n d 6  : ; : r   6 = < = < m   6 9 > > � ? ?   = o      ���� 	0 white   ;  @ A @ Z   > X B C���� B n   > F D E D 1   A E��
�� 
Fnd? E o   > A���� 0 	theresult 	theResult C r   I T F G F n   I P H I H 1   L P��
�� 
MTxt I o   I L���� 0 	theresult 	theResult G o      ���� 	0 white  ��  ��   A  J K J r   Y b L M L n   Y ^ N O N 1   \ ^��
�� 
leng O o   Y \���� 	0 white   M o      ���� 	0 wleng   K  P Q P l  c c��������  ��  ��   Q  R S R l  c c�� T U��   T * $ Define a tab based on user settings    U � V V H   D e f i n e   a   t a b   b a s e d   o n   u s e r   s e t t i n g s S  W X W r   c j Y Z Y 1   c f��
�� 
tab  Z o      ���� 0 atab aTab X  [ \ [ Z   k � ] ^���� ] 1   k q��
�� 
AuEx ^ k   t � _ _  ` a ` r   t { b c b m   t w d d � e e   c o      ���� 0 spacetab spaceTab a  f g f U   | � h i h r   � � j k j b   � � l m l o   � ����� 0 spacetab spaceTab m 1   � ���
�� 
spac k o      ���� 0 spacetab spaceTab i 1    ���
�� 
TabW g  n�� n r   � � o p o o   � ����� 0 spacetab spaceTab p o      ���� 0 atab aTab��  ��  ��   \  q r q l  � ���������  ��  ��   r  s t s l  � ��� u v��   u !  Check for list style lines    v � w w 6   C h e c k   f o r   l i s t   s t y l e   l i n e s t  x y x r   � � z { z I  � ��� | }
�� .R*chFindnull���     ctxt | m   � � ~ ~ �   . ^ \ s * [ \ * # > \ + \ - ] + ( [ \ w   ] * ) } �� � �
�� 
Opts � K   � � � � �� ���
�� 
SMod � m   � ���
�� SModGrep��   � �� ���
�� 
FnIn � l  � � ����� � 4   � ��� �
�� 
clin � o   � ����� 0 linenum lineNum��  ��  ��   { o      ���� 0 	theresult 	theResult y  � � � Z   �
 � ����� � n   � � � � � 1   � ���
�� 
Fnd? � o   � ����� 0 	theresult 	theResult � k   � � �  � � � r   � � � � � I  � ��� � �
�� .R*chFindnull���     ctxt � m   � � � � � � �  [ \ * # > \ + \ - ] + � �� � �
�� 
Opts � K   � � � � �� ���
�� 
SMod � m   � ���
�� SModGrep��   � �� ���
�� 
FnIn � l  � � ����� � 4   � ��� �
�� 
clin � o   � ����� 0 linenum lineNum��  ��  ��   � o      ���� 0 prefind preFind �  � � � r   � � � � � n   � � � � � 1   � ���
�� 
MTxt � o   � ����� 0 prefind preFind � o      ���� 	0 _char   �  � � � r   � � � � � b   � � � � � b   � � � � � o   � ���
�� 
ret  � o   � ����� 	0 white   � o   � ����� 	0 _char   � 1   � ���
�� 
pusl �  � � � I  ��� ���
�� .miscslctnull��� ��� obj  � n   � � � � � 9   � ���
�� 
cins � 1   � ���
�� 
pusl��   �  ��� � L  ����  ��  ��  ��   �  � � � l ��������  ��  ��   �  � � � l �� � ���   � 4 . Default: Insert a return plus the white space    � � � � \   D e f a u l t :   I n s e r t   a   r e t u r n   p l u s   t h e   w h i t e   s p a c e �  � � � r   � � � b   � � � o  ��
�� 
ret  � o  ���� 	0 white   � 1  ��
�� 
pusl �  ��� � I "�� ���
�� .miscslctnull��� ��� obj  � n   � � � 9  ��
�� 
cins � 1  ��
�� 
pusl��  ��    4   �� �
�� 
cwin � m    ����   m      � ��                                                                                  R*ch  alis    "  Macintosh HD               �<u�BD ����
BBEdit.app                                                     �����y��        ����  
 cu             Applications  /:Applications:BBEdit.app/   
 B B E d i t . a p p    M a c i n t o s h   H D  Applications/BBEdit.app   / ��  ��  ��     � � � l     ��������  ��  ��   �  ��� � l     ��������  ��  ��  ��       �� � ����� � ��� � � �������~�}�|�{��   � �z�y�x�w�v�u�t�s�r�q�p�o�n�m�l�k
�z .aevtoappnull  �   � ****�y 0 linenum lineNum�x 0 leng  �w 0 	theresult 	theResult�v 	0 white  �u 	0 wleng  �t 0 atab aTab�s 0 prefind preFind�r 	0 _char  �q  �p  �o  �n  �m  �l  �k   � �j ��i�h � ��g
�j .aevtoappnull  �   � **** � k    $ � �  
�f�f  �i  �h   �   � $ ��e�d�c�b�a�`�_�^ ,�]�\�[�Z�Y�X�W >�V�U�T�S�R�Q�P d�O�N�M ~ ��L�K�J�I�H
�e 
cwin
�d .miscactvnull��� ��� obj 
�c 
pusl
�b 
SLin�a 0 linenum lineNum
�` 
clin
�_ 
leng�^ 0 leng  
�] 
Opts
�\ 
SMod
�[ SModGrep
�Z 
FnIn�Y 
�X .R*chFindnull���     ctxt�W 0 	theresult 	theResult�V 	0 white  
�U 
Fnd?
�T 
MTxt�S 	0 wleng  
�R 
tab �Q 0 atab aTab
�P 
AuEx�O 0 spacetab spaceTab
�N 
TabW
�M 
spac�L 0 prefind preFind�K 	0 _char  
�J 
ret 
�I 
cins
�H .miscslctnull��� ��� obj �g%�!*�k/*j O*�,�,E�O*��/�,E�O����l�*��/� E` Oa E` O_ a ,E _ a ,E` Y hO_ �,E` O_ E` O*a ,E 1a E` O *a ,Ekh_ _ %E` [OY��O_ E` Y hOa ���l�*��/� E` O_ a ,E Ea ���l�*��/� E` O_ a ,E`  O_ !_ %_  %*�,FO*�,a "4j #OhY hO_ !_ %*�,FO*�,a "4j #UU�� ���  � �G�F�E
�G 
Fnd?
�F boovfals�E   � � � �  	 	 	��  � � � �  	 � �D�C �
�D 
Fnd?
�C boovtrue � �B � �
�B 
MSpc �  � �  ��A�@ �  ��?�>�=
�? 
TxtD�> 
�= kfrmID  
�A 
cha �@P � �< ��;
�< 
MTxt � � � �  #�;  ��  ��  �  �~  �}  �|  �{  ascr  ��ޭ