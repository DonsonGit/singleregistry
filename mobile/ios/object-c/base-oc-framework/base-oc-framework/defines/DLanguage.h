//
//  DLanguage.h
//  base-oc-framework
//
//  Created by 戴世豪 on 2018/6/26.
//  Copyright © 2018年 戴世豪. All rights reserved.
//

#ifndef DLanguage_h
#define DLanguage_h

///带格式化多语言处理
#define GT_LANGUAGE(fmt,value,replace)     ([NSString stringWithFormat:NSLocalizedString(fmt,replace),value])

///常量格式的多语言处理
#define GT_LANGUAGE_CONST(str,replace)     (NSLocalizedString(str,replace))

#endif /* DLanguage_h */
