package com.dz.kaiying.controller;

//@Controller
//@RequestMapping("/ExportExcel/*")
public class ExportExcelControl {
//
//	/**
//	 * ������ͨ�� jquery.form.js ����ṩ��ajax��ʽ����Excel
//	 * @param request
//	 * @param response
//	 * @throws Exception
//	 */
//	@RequestMapping(value="ajaxExport.do",method={RequestMethod.GET,RequestMethod.POST})
//	public  String  ajaxUploadExcel(HttpServletRequest request,HttpServletResponse response) throws Exception {
//		System.out.println("ͨ�� jquery.form.js �ṩ��ajax��ʽ�����ļ���");
//		OutputStream os = null;
//		Workbook wb = null;    //������
//
//		try {
//			//ģ�����ݿ�ȡֵ
//			List<InfoVo> lo = new ArrayList<InfoVo>();
//			for (int i = 0; i < 8; i++) {
//				InfoVo vo = new InfoVo();
//				vo.setCode("110"+i);
//				vo.setDate("2015-11-0"+i);
//				vo.setMoney("1000"+i+".00");
//				vo.setName("������֧0"+i);
//				lo.add(vo);
//			}
//
//			//����Excel�ļ�����
//			ExportExcelUtil util = new ExportExcelUtil();
//			File file =util.getExcelDemoFile("/ExcelDemo/�¹�ģ��.xlsx");
//			String sheetName="sheet1";
//			wb = util.writeNewExcel(file, sheetName,lo);
//
//			String fileName="������.xlsx";
//			response.setContentType("application/vnd.ms-excel");
//			response.setHeader("Content-disposition", "attachment;filename="+ URLEncoder.encode(fileName, "utf-8"));
//			os = response.getOutputStream();
//			wb.write(os);
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
//		finally{
//			os.flush();
//			os.close();
//			wb.close();
//		}
//		return null;
//	}


}
