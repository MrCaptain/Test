
::����PLT(Persistent Lookup Table)

@echo "--------------------------------------------------------"
@echo "��ʼ����PLT..."
@echo "Ĭ�Ͻ���PLT�Ŀ�: kernel stdlib inets compiler erts tools"
@echo "������Ҫ���������"
@echo "--------------------------------------------------------"

set HOME=%TMP%
dialyzer --build_plt --apps kernel stdlib inets compiler erts tools --output_plt dialyzer.plt

@echo "--------------------------------------------------------"
@echo "�����,��Ŀ¼��: dialyzer.plt"
@echo "--------------------------------------------------------"
pause
